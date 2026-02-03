# Sentry configuration for error monitoring
# Gratuit jusqu'à 5,000 errors/mois
# https://sentry.io

Sentry.init do |config|
  # DSN (Data Source Name) - À configurer en production
  config.dsn = ENV['SENTRY_DSN']

  # Ne pas envoyer en développement
  config.enabled_environments = %w[production staging]

  # Environment
  config.environment = Rails.env

  # Release tracking (pour voir quelle version a causé l'erreur)
  config.release = ENV['GIT_COMMIT_SHA'] || 'unknown'

  # Breadcrumbs (traçage des actions avant l'erreur)
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Traces sample rate (performance monitoring)
  # 0.0 = désactivé, 1.0 = 100% des transactions
  config.traces_sample_rate = ENV.fetch('SENTRY_TRACES_SAMPLE_RATE', 0.1).to_f

  # Envoyer les informations de contexte (headers, IP, etc.)
  config.send_default_pii = true

  # Filtrer les paramètres sensibles
  config.before_send = lambda do |event, hint|
    # Filtrer les mots de passe, tokens, etc.
    if event.request
      event.request.data = event.request.data&.except(
        'password',
        'password_confirmation',
        'oauth_token',
        'oauth_refresh_token',
        'encrypted_password'
      )
    end

    event
  end

  # Ignorer certaines erreurs communes/non critiques
  config.excluded_exceptions += [
    'ActionController::RoutingError',
    'ActiveRecord::RecordNotFound'
  ]
end
