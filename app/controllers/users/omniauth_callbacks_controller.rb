# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: [:github, :google_oauth2]

  def github
    handle_oauth("GitHub")
  end

  def google_oauth2
    handle_oauth("Google")
  end

  def failure
    redirect_to root_path, alert: "Authentification annulée ou échouée."
  end

  private

  def handle_oauth(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = "Connecté avec #{provider}!"
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.oauth_data"] = request.env["omniauth.auth"].except(:extra)
      flash[:alert] = "Erreur lors de la création du compte: #{@user.errors.full_messages.join(', ')}"
      redirect_to new_user_registration_url
    end
  end
end
