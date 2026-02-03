# frozen_string_literal: true

# Rack::Attack configuration pour la protection contre les attaques
# Documentation: https://github.com/rack/rack-attack

class Rack::Attack
  ### Throttle les tentatives de connexion par IP ###
  # Limite: 5 tentatives par minute
  throttle("logins/ip", limit: 5, period: 60.seconds) do |req|
    if req.path == "/users/sign_in" && req.post?
      req.ip
    end
  end

  ### Throttle les tentatives de connexion par email ###
  # Limite: 5 tentatives par minute par email
  throttle("logins/email", limit: 5, period: 60.seconds) do |req|
    if req.path == "/users/sign_in" && req.post?
      # Normaliser l'email pour éviter les contournements
      req.params.dig("user", "email")&.to_s&.downcase&.gsub(/\s+/, "")
    end
  end

  ### Throttle les inscriptions par IP ###
  # Limite: 3 inscriptions par heure par IP
  throttle("signups/ip", limit: 3, period: 1.hour) do |req|
    if req.path == "/users" && req.post?
      req.ip
    end
  end

  ### Throttle les demandes de reset password ###
  # Limite: 5 par heure
  throttle("password_reset/ip", limit: 5, period: 1.hour) do |req|
    if req.path == "/users/password" && req.post?
      req.ip
    end
  end

  ### Throttle les actions join/leave sur les projets ###
  # Limite: 10 par heure
  throttle("project_actions/ip", limit: 10, period: 1.hour) do |req|
    if req.path.match?(%r{/projects/\d+/(join|leave)}) && (req.post? || req.delete?)
      req.ip
    end
  end

  ### Throttle l'envoi de messages ###
  # Limite: 30 messages par minute
  throttle("messages/ip", limit: 30, period: 60.seconds) do |req|
    if req.path.match?(%r{/projects/\d+/messages}) && req.post?
      req.ip
    end
  end

  ### Throttle toggle availability ###
  # Limite: 10 par minute
  throttle("availability/ip", limit: 10, period: 60.seconds) do |req|
    if req.path.match?(%r{/users/\d+/toggle_availability}) && req.patch?
      req.ip
    end
  end

  ### Throttle général pour toutes les requêtes ###
  # Limite: 300 requêtes par 5 minutes
  throttle("requests/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets", "/packs")
  end

  ### Blocklist des IPs suspectes (optionnel) ###
  # Décommenter et ajouter des IPs si nécessaire
  # blocklist("block bad IPs") do |req|
  #   ["1.2.3.4", "5.6.7.8"].include?(req.ip)
  # end

  ### Safelist pour les IPs de confiance ###
  # Les requêtes de localhost ne sont pas limitées en dev
  safelist("allow localhost") do |req|
    req.ip == "127.0.0.1" || req.ip == "::1"
  end

  ### Configuration des réponses ###
  # Réponse personnalisée quand limite atteinte
  self.throttled_responder = lambda do |request|
    match_data = request.env["rack.attack.match_data"]
    now = match_data[:epoch_time]
    retry_after = match_data[:period] - (now % match_data[:period])

    [
      429,
      {
        "Content-Type" => "application/json",
        "Retry-After" => retry_after.to_s
      },
      [{ error: "Trop de requêtes. Réessayez dans #{retry_after} secondes." }.to_json]
    ]
  end
end

# Utiliser Redis pour le rate limiting (partagé entre tous les serveurs)
# En développement, Redis tourne en local. En production, utiliser REDIS_URL
Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
  url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'),
  namespace: 'nexp_rack_attack'
)
