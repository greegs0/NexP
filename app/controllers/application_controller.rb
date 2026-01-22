class ApplicationController < ActionController::Base
  include Securable

  # Configuration Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Use devise layout for authentication pages
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller? && !(controller_name == 'registrations' && action_name == 'edit')
      "devise"
    else
      "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :zipcode])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :username, :name, :bio, :zipcode, :portfolio_url, :github_url,
      :linkedin_url, :avatar_url, :available
    ])
  end

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def after_sign_up_path_for(resource)
    dashboard_path
  end
end
