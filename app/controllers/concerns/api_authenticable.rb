module ApiAuthenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api_user!
  end

  private

  def authenticate_api_user!
    token = extract_token_from_header

    unless token
      render json: { error: 'Token manquant' }, status: :unauthorized
      return
    end

    decoded_token = JsonWebToken.decode(token)

    unless decoded_token
      render json: { error: 'Token invalide ou expiré' }, status: :unauthorized
      return
    end

    @current_api_user = User.find_by(id: decoded_token[:user_id])

    unless @current_api_user
      render json: { error: 'Utilisateur non trouvé' }, status: :unauthorized
      return
    end
  end

  def current_api_user
    @current_api_user
  end

  def extract_token_from_header
    header = request.headers['Authorization']
    return nil unless header.present?

    # Format attendu: "Bearer <token>"
    header.split(' ').last if header.split(' ').first == 'Bearer'
  end
end
