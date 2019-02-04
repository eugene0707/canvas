class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :assign_resource, only: %i[destroy show edit update]
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :verify_authorized, except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :render_not_unique
  rescue_from ActionController::ParameterMissing, with: :render_no_parameters
  rescue_from Pundit::NotAuthorizedError, with: :render_not_authorized

  def new; end

  def create
    assign_resource(resource_class.new(resource_params))

    if resource.save
      render :show, status: :created
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  def destroy
    resource.destroy
    head :no_content
  end

  def index
    plural_resource_name = "@#{resource_name.pluralize}"
    resources = policy_scope(resource_class)
                .where(query_params).page(page_params[:page]).per(page_params[:page_size])

    instance_variable_set(plural_resource_name, resources)
  end

  def show; end

  def edit; end

  def update
    if resource.update(resource_params)
      render :show
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def resource
    instance_variable_get("@#{resource_name}")
  end

  def query_params
    {}
  end

  def page_params
    params.permit(:page, :page_size)
  end

  def resource_class
    @resource_class ||= resource_name.classify.constantize
  end

  def resource_name
    @resource_name ||= controller_name.singularize
  end

  def resource_params
    send("#{resource_name}_params") || params.require(resource_name.to_sym).permit(
      policy(@post).permitted_attributes(action_name.to_sym)
    )
  end

  # Use callbacks to share common setup or constraints between actions.
  def assign_resource(value = nil)
    value ||= authorize(resource_class.find(params[:id]))
    instance_variable_set("@#{resource_name}", value)
  end

  def render_not_found
    flash[:error] = t('exceptions.not_found')
    redirect_to(root_path, status: :not_found)
  end

  def render_not_unique
    flash[:error] = t('exceptions.not_unique')
    redirect_to(:back, status: :unprocessable_entity)
  end

  def render_no_parameters
    flash[:error] = t('exceptions.no_parameters')
    redirect_to(:back, status: :unprocessable_entity)
  end

  def render_not_authorized
    flash[:error] = t('exceptions.forbidden')
    redirect_to(root_path, status: :forbidden)
  end
end
