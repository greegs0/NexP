class ApplicationController < ActionController::Base
  include Securable

  # Configuration Devise
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :zipcode])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :username, :name, :bio, :zipcode, :portfolio_url, :github_url,
      :linkedin_url, :avatar_url, :available
    ])
  end
end
