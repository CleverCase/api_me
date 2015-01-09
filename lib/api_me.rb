require 'active_support/concern'
require 'pundit'
require 'search_object'

require 'api_me/version'
require 'api_me/base_filter'

module ApiMe
  extend ActiveSupport::Concern
  include ::Pundit

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
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
    ids_filter_hash = params[:ids] ? { ids: params[:ids] } : {}
    @scoped_objects = policy_scope(resource_scope)
    @filter_objects = filter_klass.new(
        scope: @scoped_objects,
        filters: (filter_params || {}).merge(ids_filter_hash)
    )

    render json: @filter_objects.results, each_serializer: serializer_klass
  end

  def show
    @object = model_klass.find(params[:id])
    authorize @object

    render json: @object, serializer: serializer_klass
  end

  def create
    @object = model_klass.new(object_params)
    authorize @object
    @object.save!(object_params)

    render status: 201, json: @object, serializer: serializer_klass
  rescue ActiveRecord::RecordInvalid => e
    handle_errors(e)
  end

  def update
    @object = model_klass.find(params[:id])
    authorize @object
    @object.update!(object_params)

    render status: 204, nothing: true
  rescue ActiveRecord::RecordInvalid => e
    handle_errors(e)
  end

  def destroy
    @object = model_klass.find(params[:id])
    authorize @object
    @object.destroy

    render status: 204, nothing: true
  end

  private

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

  def params_klass_symbol
    model_klass.name.demodulize.underscore.to_sym
  end

  def filter_params
    params[:filters]
  end
end
