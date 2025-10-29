# frozen_string_literal: true

require 'active_support/concern'
require 'pundit'
require 'search_object'
require 'kaminari'

require 'api_me/version'
require 'api_me/base_filter'
require 'api_me/sorting'
require 'api_me/pagination'
require 'api_me/csv_stream_writer'

module ApiMe
  extend ActiveSupport::Concern

  included do
    include ::Pundit
    include ActionController::Live

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordInvalid, with: :handle_active_record_errors
    rescue_from ActiveRecord::RecordNotDestroyed, with: :handle_active_record_errors
    rescue_from ActiveRecord::ReadOnlyRecord, with: :handle_active_record_errors
    rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
  end

  module ClassMethods
    def model(klass)
      @model_klass = klass
    end

    def serializer(klass)
      @serializer_klass = klass
    end

    if RUBY_VERSION >= '2.0'
      def model_klass
        @model_klass ||= Object.const_get(model_klass_name)
      end

      def serializer_klass
        @serializer_klass ||= Object.const_get(serializer_klass_name)
      end
    else
      def model_klass
        @model_klass ||= model_klass_name.safe_constantize
      end

      def serializer_klass
        @serializer_klass ||= serializer_klass_name.safe_constantize
      end
    end

    def filter_klass
      @filter_klass ||= filter_klass_name.safe_constantize || ::ApiMe::BaseFilter
    end

    def model_klass_name
      @model_klass_name ||= name.demodulize.sub(/Controller$/, '').singularize
    end

    def serializer_klass_name
      @serializer_klass_name ||= "#{model_klass_name}Serializer"
    end

    def filter_klass_name
      @filter_klass_name ||= "#{model_klass_name}Filter"
    end
  end

  # Currently merge params[:ids] in filters hash
  # to support common use case of filtering ids using
  # the top level ids array param. Would eventually like
  # to move to support the jsonapi.org standard closer.
  def index
    @policy_scope = policy_scope(resource_scope)
    @filter_scope = filter_scope(@policy_scope)
    @sorted_scope = sort_scope(@filter_scope)
    @pagination_object = paginate_scope(@sorted_scope, page_params)

    respond_to do |format|
      format.csv do
        @csv_includes_scope = csv_includes_scope(@sorted_scope)
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Cache-Control'] = 'no-cache'
        # Hack to work around https://github.com/rack/rack/issues/1619
        response.headers['Last-Modified'] = Time.current.httpdate
        # Disable gzip in nginx
        response.headers['X-Accel-Buffering'] = 'no'
        response.headers['Content-Disposition'] = "attachment; filename=\"#{csv_filename}\""

        ::ApiMe::CsvStreamWriter.generate(response.stream) do |csv|
          # headers
          csv << csv_headers
          @csv_includes_scope.find_each do |object|
            csv << object.try('to_csv')
          end
        end
      ensure
        response.stream.close
      end
      format.all do
        render(
          json: @pagination_object.results,
          root: collection_root_key,
          each_serializer: serializer_klass,
          meta: {
            page: @pagination_object.page_meta,
            sort: sorting_meta(@filter_scope)
          }
        )
      end
    end
  end

  def show
    @object = find_resource
    authorize_resource @object

    render json: @object, root: singular_root_key, serializer: serializer_klass
  end

  def new
    render_errors(['new endpoint not supported'], :not_found)
  end

  def create
    @object = build_resource
    authorize_resource @object
    create_resource!

    render status: :created, json: @object, root: singular_root_key, serializer: serializer_klass
  end

  def edit
    render_errors(['edit endpoint not supported'], :not_found)
  end

  def update
    @object = find_resource
    @object.assign_attributes(object_params)
    authorize_resource @object
    update_resource!

    render status: :ok, json: @object, root: singular_root_key, serializer: serializer_klass
  end

  def destroy
    @object = find_resource
    authorize_resource @object
    destroy_resource!

    head :no_content
  end

  protected

  def csv_filename
    "#{model_klass.name.dasherize}-#{Time.zone.now.to_date.to_fs(:default)}.csv"
  end

  def csv_headers
    model_klass.respond_to?('csv_headers') ? model_klass.csv_headers : []
  end

  def csv_includes_scope(scope)
    scope
  end

  def singular_root_key
    model_klass.name.singularize.underscore
  end

  def collection_root_key
    model_klass.name.pluralize.underscore
  end

  def object_params
    params.require(params_klass_symbol).permit(*policy(@object || model_klass).permitted_attributes)
  end

  def page_params
    params[:page]
  end

  def sort_params
    params[:sort]
  end

  def render_errors(errors, status = :unprocessable_entity)
    render(json: { errors: errors }, status: status)
  end

  def handle_active_record_errors(active_record_error)
    Rails.logger.debug "ERROR: #{active_record_error}"
    render_errors(active_record_error.record.errors.messages)
  end
  alias handle_errors handle_active_record_errors

  def user_not_authorized
    payload = { message: "User is not allowed to access #{params[:action]} on this resource" }
    render json: payload, status: :forbidden
  end

  def resource_not_found
    head :not_found
  end

  def model_klass
    self.class.model_klass
  end

  def serializer_klass
    self.class.serializer_klass
  end

  def filter_klass
    self.class.filter_klass
  end

  def sort_klass
    ApiMe::Sorting
  end

  def resource_scope
    model_klass.all
  end

  def filter_scope(scope)
    filter_klass.new(
      scope: scope,
      filters: filters_hash
    ).results
  end

  def sorting_meta(scope, sortable_params = sort_params)
    sort_klass.new(
      scope: scope,
      sort_params: sortable_params
    ).sort_meta
  end

  def sort_scope(scope, sortable_params = sort_params)
    sort_klass.new(
      scope: scope,
      sort_params: sortable_params
    ).results
  end

  def paginate_scope(scope, params)
    ApiMe::Pagination.new(scope: scope, page_params: params)
  end

  def params_klass_symbol
    model_klass.name.demodulize.underscore.to_sym
  end

  def filters_hash
    ids_filter_hash = params[:ids] ? { ids: params[:ids] } : {}
    (filter_params || {}).merge(ids_filter_hash)
  end

  def filter_params
    params[:filters]
  end

  def find_resource
    @find_resource ||= model_klass.find_by!(id: params[:id])
  end

  def build_resource
    @build_resource ||= model_klass.new(object_params)
  end

  def create_resource!
    @object.save!
  end

  def update_resource!
    @object.save!
  end

  def destroy_resource!
    @object.destroy!
  end

  def authorize_resource(resource)
    authorize resource
  end
end
