module ApplicationHelper
  # Styles des badges par nom
  BADGE_STYLES = {
    # Badges de niveau
    'Débutant' => { color: '#94a3b8', icon: 'user-plus' },
    'Apprenti' => { color: '#64748b', icon: 'book-open' },
    'Intermédiaire' => { color: '#3b82f6', icon: 'trending-up' },
    'Avancé' => { color: '#8b5cf6', icon: 'check-circle' },
    'Expert' => { color: '#10b981', icon: 'badge-check' },
    'Maître' => { color: '#f59e0b', icon: 'star' },
    'Légende' => { color: '#ef4444', icon: 'fire' },

    # Badges de projets
    'Premier Projet' => { color: '#10b981', icon: 'clipboard' },
    'Entrepreneur' => { color: '#6366f1', icon: 'briefcase' },
    'Chef de Projet' => { color: '#ec4899', icon: 'users' },
    'Collaborateur' => { color: '#14b8a6', icon: 'user-group' },
    'Team Player' => { color: '#f97316', icon: 'hand-raised' },
    'Vétéran' => { color: '#84cc16', icon: 'shield-check' },

    # Badges sociaux
    'Première Publication' => { color: '#ec4899', icon: 'pencil' },
    'Blogueur' => { color: '#a855f7', icon: 'document-text' },
    'Influenceur' => { color: '#f43f5e', icon: 'megaphone' },
    'Commentateur' => { color: '#06b6d4', icon: 'chat-bubble' },
    'Populaire' => { color: '#eab308', icon: 'heart' },
    'Célébrité' => { color: '#ef4444', icon: 'sparkles' },
    'Social' => { color: '#22c55e', icon: 'user-group' },

    # Badges d'activité
    'Polyvalent' => { color: '#6366f1', icon: 'view-grid' },
    'Expert Multi-Domaines' => { color: '#ef4444', icon: 'star' },
    'Communicateur' => { color: '#0ea5e9', icon: 'chat' },
    'Bavard' => { color: '#f97316', icon: 'chat-bubble-left-right' }
  }.freeze

  # Retourne le style d'un badge par son nom
  #
  # @param badge_name [String] Le nom du badge
  # @return [Hash] Le style avec :color et :icon
  def badge_style(badge_name)
    clean_name = clean_badge_name(badge_name)
    BADGE_STYLES[clean_name] || { color: '#8fa66b', icon: 'sparkles' }
  end

  # Nettoie le nom du badge en supprimant les emojis
  #
  # @param badge_name [String] Le nom du badge avec potentiels emojis
  # @return [String] Le nom nettoyé
  def clean_badge_name(badge_name)
    badge_name.gsub(/[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]+\s*/u, '').strip
  end

  # Helper pour les statuts de projet
  #
  # @param status [String] Le statut du projet
  # @return [Hash] Classes CSS et label
  def project_status_badge(status)
    styles = {
      'open' => { class: 'bg-green-500/20 text-green-500', label: 'Ouvert' },
      'in_progress' => { class: 'bg-blue-500/20 text-blue-500', label: 'En cours' },
      'completed' => { class: 'bg-purple-500/20 text-purple-500', label: 'Terminé' },
      'on_hold' => { class: 'bg-yellow-500/20 text-yellow-500', label: 'En pause' },
      'cancelled' => { class: 'bg-red-500/20 text-red-500', label: 'Annulé' }
    }
    styles[status] || { class: 'bg-gray-500/20 text-gray-500', label: status.humanize }
  end

  # Sanitize SVG content for safe rendering
  # Allows only safe SVG elements and attributes
  #
  # @param svg_content [String] Raw SVG path elements
  # @return [ActiveSupport::SafeBuffer] Sanitized SVG content
  def safe_svg(svg_content)
    sanitize(svg_content, tags: %w[path circle rect line polyline polygon ellipse g],
             attributes: %w[d fill stroke stroke-width stroke-linecap stroke-linejoin
                            viewBox cx cy r x y width height points transform
                            fill-rule clip-rule opacity])
  end

  # Helper pour le temps relatif en français
  #
  # @param time [Time] Le temps à afficher
  # @return [String] Le temps relatif
  def time_ago_french(time)
    distance = Time.current - time
    case distance
    when 0..59 then "à l'instant"
    when 60..3599 then "il y a #{(distance / 60).to_i} min"
    when 3600..86399 then "il y a #{(distance / 3600).to_i}h"
    when 86400..604799 then "il y a #{(distance / 86400).to_i}j"
    else time.strftime('%d/%m/%Y')
    end
  end
end
