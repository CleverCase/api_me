require 'active_support/concern'
require 'pundit'

require 'api_me/version'

module ApiMe
  extend ActiveSupport::Concern
  include ::Pundit

	included do

    protect_from_forgery :with => :null_session
    rescue_from Pundit::NotAuthorizedError, :with => :user_not_authorized

    after_action :verify_authorized, :except => :index
    after_action :verify_policy_scoped, :only => :index
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

    def model_klass_name
      @model_klass_name ||= self.name.demodulize.sub(/Controller$/, '').singularize
    end

    def serializer_klass_name
      @serializer_klass_name ||= "#{self.name.demodulize.sub(/Controller$/, '').singularize}Serializer"
    end

    def params_klass_symbol
      self.model_klass.name.downcase.to_sym
    end
  end

  def index
    @scoped_objects = policy_scope(model_klass.all)
    render :json => @scoped_objects, :each_serializer => serializer_klass
  end

  def show
    @object = model_klass.find(params[:id])
    authorize @object

    render :json => @object, :serializer => serializer_klass
  end

  def create
    begin
      @object = model_klass.new(object_params)
      authorize @object
      @object.save!(object_params)

      render :status => 201, :json => @object, :serializer => serializer_klass
    rescue ActiveRecord::RecordInvalid => e
      handle_errors(e)
    end
  end

  def update
    begin
      @object = model_klass.find(params[:id])
      authorize @object
      @object.update!(object_params)

      render :status => 204, :nothing => true
    rescue ActiveRecord::RecordInvalid => e
      handle_errors(e)
    end
  end

  def destroy
    @object = model_klass.find(params[:id])
    authorize @object
    @object.destroy()

    render :status => 204, :nothing => true
  end

  private

  def object_params
    params.require(params_klass_symbol).permit(*policy(@object || model_klass).permitted_attributes)
  end

  def render_errors(errors, status = 422)
    render(:json => {errors: errors}, :status => status)
  end

  def handle_errors(e)
    render_errors(e.record.errors.messages)
  end

  def user_not_authorized
    payload = { :message => "User is not allowed to access #{params[:action]} on this resource"}
    render :json => payload, :status => 403
  end

  def params_klass_symbol
    self.class.params_klass_symbol
  end

  def model_klass
    self.class.model_klass
  end

  def serializer_klass
    self.class.serializer_klass
  end
end
