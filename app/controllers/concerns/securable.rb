module Securable
  extend ActiveSupport::Concern

  included do
    # Protection CSRF activée par défaut
    protect_from_forgery with: :exception

    # Définir les headers de sécurité
    before_action :set_security_headers

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
  end

  private

  def set_security_headers
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    response.headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
  end

  def record_not_found
    redirect_to root_path, alert: "La ressource demandée n'existe pas."
  end

  def parameter_missing(exception)
    redirect_back fallback_location: root_path, alert: "Paramètres manquants : #{exception.param}"
  end
end
