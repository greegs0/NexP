# frozen_string_literal: true

# Configuration de la Content Security Policy (CSP)
# Protection contre XSS, injection de scripts, etc.
#
# Documentation: https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP

Rails.application.config.content_security_policy do |policy|
  # Sources par défaut
  policy.default_src :self, :https

  # Scripts JavaScript
  # :unsafe_inline nécessaire pour Turbo/Stimulus inline scripts
  # :unsafe_eval peut être retiré si vous n'utilisez pas eval()
  policy.script_src  :self, :https, :unsafe_inline, :unsafe_eval

  # Styles CSS
  # :unsafe_inline nécessaire pour Tailwind et styles inline
  policy.style_src   :self, :https, :unsafe_inline

  # Images
  # data: pour les images base64
  # blob: pour les images générées côté client
  policy.img_src     :self, :https, :data, :blob

  # Polices
  policy.font_src    :self, :https, :data

  # Connexions (fetch, XHR, WebSocket, EventSource)
  policy.connect_src :self, :https, "ws://localhost:*", "wss://*"

  # Frames (iframes)
  policy.frame_src   :self, :https

  # Objets (plugins comme Flash)
  policy.object_src  :none

  # Médias (audio, video)
  policy.media_src   :self, :https

  # Workers
  policy.worker_src  :self, :blob

  # Manifests (PWA)
  policy.manifest_src :self

  # Forms (où les formulaires peuvent être soumis)
  policy.form_action :self, :https

  # Frame ancestors (protection contre clickjacking)
  policy.frame_ancestors :self

  # Base URI (restriction des URLs de base)
  policy.base_uri :self

  # Upgrade insecure requests (force HTTPS)
  # Décommenter en production avec HTTPS
  # policy.upgrade_insecure_requests true

  # Rapport des violations (optionnel)
  # Configuration pour recevoir les rapports de violations CSP
  # policy.report_uri "/csp-violation-report-endpoint"
end

# Générer un nonce pour chaque requête (recommandé pour production)
# Cela permet d'utiliser des scripts inline de manière sécurisée
Rails.application.config.content_security_policy_nonce_generator = ->(request) {
  # Générer un nonce unique par requête
  SecureRandom.base64(16)
}

# Utiliser le nonce pour les scripts et styles inline
# Ajouter automatiquement nonce: true aux script_tag et style_tag
Rails.application.config.content_security_policy_nonce_directives = %w[script-src style-src]

# Mode Report-Only pour tester sans bloquer (décommenter pour debug)
# Rails.application.config.content_security_policy_report_only = true
