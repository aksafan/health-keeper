class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email])
  end

  def after_sign_in_path_for(resource)
    health_records_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_back_or_to(root_path)
  end

  def record_not_found(e)
    Rails.logger.debug("Entity #{e.model} with id #{e.id} is not found.")

    render :file => "#{::Rails.root}/public/404.html",  :status => 404
  end
end
