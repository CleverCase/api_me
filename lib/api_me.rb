require 'active_support/concern'
require 'pundit'
require 'search_object'
require 'kaminari'

require 'api_me/version'
require 'api_me/base_filter'
require 'api_me/sorting'
require 'api_me/pagination'

module ApiMe
  extend ActiveSupport::Concern
  include ::Pundit

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
  end

  module ClassMethods
    def model(klass) # rubocop:disable TrivialAccessors
      @model_klass = klass
    end

    def serializer(klass) # rubocop:disable TrivialAccessors
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
      @serializer_klass_name ||= "#{name.demodulize.sub(/Controller$/, '').singularize}Serializer"
    end

    def filter_klass_name
      @filter_klass_name ||= "#{name.demodulize.sub(/Controller$/, '').singularize}Filter"
    end
  end

  # Currently merge params[:ids] in filters hash
  # to support common use case of filtering ids using
  # the top level ids array param. Would eventually like
  # to move to support the jsonapi.org standard closer.
  def index
    @policy_scope = policy_scope(resource_scope)
    @filter_scope = filter_scope(@policy_scope)
    @sorted_scope = sort_scope(@filter_scope, params[:sort])
    @pagination_object = ApiMe::Pagination.new(scope: @sorted_scope, page_params: params[:page])

    render json: @pagination_object.results, root: collection_root_key, each_serializer: serializer_klass, meta: { page: @pagination_object.page_meta }
  end

  def show
    @object = find_resource
    authorize @object

    render json: @object, root: singular_root_key, serializer: serializer_klass
  end

  def create
    @object = model_klass.new(object_params)
    authorize @object
    @object.save!(object_params)

    render status: 201, json: @object, root: singular_root_key, serializer: serializer_klass
  rescue ActiveRecord::RecordInvalid => e
    handle_errors(e)
  end

  def update
    @object = find_resource
    authorize @object
    @object.update!(object_params)

    render status: 204, nothing: true
  rescue ActiveRecord::RecordInvalid => e
    handle_errors(e)
  end

  def destroy
    @object = find_resource
    authorize @object
    @object.destroy
    render status: 204, nothing: true
  rescue ActiveRecord::RecordInvalid => e
    handle_errors(e)
  end

  protected

  def singular_root_key
    model_klass.name.singularize.underscore
  end

  def collection_root_key
    model_klass.name.pluralize.underscore
  end

  def object_params
    params.require(params_klass_symbol).permit(*policy(@object || model_klass).permitted_attributes)
  end

  def render_errors(errors, status = 422)
    render(json: { errors: errors }, status: status)
  end

  def handle_errors(e)
    Rails.logger.debug "ERROR: #{e}"
    render_errors(e.record.errors.messages)
  end

  def user_not_authorized
    payload = { message: "User is not allowed to access #{params[:action]} on this resource" }
    render json: payload, status: 403
  end

  def resource_not_found
    render status: 404, nothing: true
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

  def resource_scope
    model_klass.all
  end

  def filter_scope(scope)
    filter_klass.new(
        scope: scope,
        filters: filters_hash
    ).results
  end

  def sort_scope(scope, params)
    ApiMe::Sorting.new(scope: scope, sort_params: params).results
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
    model_klass.find_by_id!(params[:id])
  end
end
