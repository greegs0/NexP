class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Rediriger vers la page de saisie du code après l'inscription
  def after_inactive_sign_up_path_for(resource)
    flash[:notice] = "Compte créé ! 📧 Vérifie ton email pour récupérer ton code de confirmation."
    verify_code_users_confirmation_path(email: resource.email)
  end
end
