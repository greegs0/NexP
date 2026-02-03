class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /users/confirmation/new
  def new
    super
  end

  # POST /users/confirmation
  def create
    super
  end

  # GET /users/confirmation?confirmation_token=abcdef
  def show
    # Rediriger vers la page de saisie du code
    redirect_to verify_code_users_confirmation_path
  end

  # GET /users/confirmation/verify_code
  def verify_code
    # Page pour entrer le code à 6 chiffres
  end

  # POST /users/confirmation/confirm_code
  def confirm_code
    email = params[:email]
    code = params[:code]

    user = User.find_by(email: email)

    if user.nil?
      flash[:alert] = "Aucun compte trouvé avec cet email."
      redirect_to verify_code_users_confirmation_path(email: email) and return
    end

    if user.confirmed?
      flash[:notice] = "Ton compte est déjà confirmé ! Tu peux te connecter."
      redirect_to new_user_session_path and return
    end

    if user.confirm_with_code(code)
      flash[:notice] = "✅ Email confirmé ! Bienvenue sur NexP #{user.username} !"
      sign_in(user)
      redirect_to root_path
    else
      if code.blank? || code.length != 6
        flash[:alert] = "Le code doit contenir exactement 6 chiffres."
      elsif user.confirmation_code != code
        flash[:alert] = "❌ Code incorrect. Vérifie ton email et réessaie."
      elsif user.confirmation_code_sent_at < 15.minutes.ago
        flash[:alert] = "⏱️ Ce code a expiré. Clique sur 'Renvoyer le code' pour en recevoir un nouveau."
      else
        flash[:alert] = "Une erreur est survenue. Réessaie ou demande un nouveau code."
      end
      redirect_to verify_code_users_confirmation_path(email: email)
    end
  end

  # POST /users/confirmation/resend_code
  def resend_code
    email = params[:email]
    user = User.find_by(email: email, confirmed_at: nil)

    if user
      user.send_confirmation_instructions
      flash[:notice] = "📧 Nouveau code envoyé à #{email} ! Vérifie ta boîte mail."
    else
      flash[:alert] = "Aucun compte non confirmé trouvé avec cet email."
    end

    redirect_to verify_code_users_confirmation_path(email: email)
  end
end
