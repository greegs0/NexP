module NotificationsHelper
  # Icônes SVG pour les notifications
  NOTIFICATION_ICONS = {
    'heart' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>',
    'chat' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>',
    'reply' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6"/>',
    'user-plus' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/>',
    'at' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"/>',
    'users' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>',
    'mail' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>',
    'refresh' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>',
    'star' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"/>',
    'trending-up' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>',
    'award' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-.806 3.42 3.42 0 014.438 0 3.42 3.42 0 001.946.806 3.42 3.42 0 013.138 3.138 3.42 3.42 0 00.806 1.946 3.42 3.42 0 010 4.438 3.42 3.42 0 00-.806 1.946 3.42 3.42 0 01-3.138 3.138 3.42 3.42 0 00-1.946.806 3.42 3.42 0 01-4.438 0 3.42 3.42 0 00-1.946-.806 3.42 3.42 0 01-3.138-3.138 3.42 3.42 0 00-.806-1.946 3.42 3.42 0 010-4.438 3.42 3.42 0 00.806-1.946 3.42 3.42 0 013.138-3.138z"/>',
    'bookmark' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z"/>',
    'calendar' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>',
    'bell' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>'
  }.freeze

  # Classes de couleurs pour les notifications
  NOTIFICATION_COLORS = {
    'rose' => {
      bg: 'bg-rose-500/10',
      text: 'text-rose-500',
      border: 'border-rose-500/20',
      ring: 'ring-rose-500/30'
    },
    'blue' => {
      bg: 'bg-blue-500/10',
      text: 'text-blue-500',
      border: 'border-blue-500/20',
      ring: 'ring-blue-500/30'
    },
    'purple' => {
      bg: 'bg-purple-500/10',
      text: 'text-purple-500',
      border: 'border-purple-500/20',
      ring: 'ring-purple-500/30'
    },
    'green' => {
      bg: 'bg-green-500/10',
      text: 'text-green-500',
      border: 'border-green-500/20',
      ring: 'ring-green-500/30'
    },
    'yellow' => {
      bg: 'bg-yellow-500/10',
      text: 'text-yellow-500',
      border: 'border-yellow-500/20',
      ring: 'ring-yellow-500/30'
    },
    'indigo' => {
      bg: 'bg-indigo-500/10',
      text: 'text-indigo-500',
      border: 'border-indigo-500/20',
      ring: 'ring-indigo-500/30'
    },
    'cyan' => {
      bg: 'bg-cyan-500/10',
      text: 'text-cyan-500',
      border: 'border-cyan-500/20',
      ring: 'ring-cyan-500/30'
    },
    'teal' => {
      bg: 'bg-teal-500/10',
      text: 'text-teal-500',
      border: 'border-teal-500/20',
      ring: 'ring-teal-500/30'
    },
    'amber' => {
      bg: 'bg-amber-500/10',
      text: 'text-amber-500',
      border: 'border-amber-500/20',
      ring: 'ring-amber-500/30'
    },
    'orange' => {
      bg: 'bg-orange-500/10',
      text: 'text-orange-500',
      border: 'border-orange-500/20',
      ring: 'ring-orange-500/30'
    },
    'primary' => {
      bg: 'bg-primary/10',
      text: 'text-primary',
      border: 'border-primary/20',
      ring: 'ring-primary/30'
    },
    'gray' => {
      bg: 'bg-muted',
      text: 'text-muted-foreground',
      border: 'border-border',
      ring: 'ring-muted'
    }
  }.freeze

  # Avatar utilisateur avec initiale ou image
  def user_avatar(user, size: 10)
    return unless user

    if user.avatar.attached?
      image_tag user.avatar.variant(resize_to_limit: [size * 4, size * 4]),
                class: "w-#{size} h-#{size} rounded-full object-cover ring-2 ring-border",
                alt: user.display_name
    else
      content_tag :div, class: "w-#{size} h-#{size} rounded-full bg-gradient-to-br from-primary to-primary/60 flex items-center justify-center ring-2 ring-primary/20" do
        content_tag :span, user.display_name[0].upcase, class: "text-white font-bold text-#{size == 10 ? 'base' : 'sm'}"
      end
    end
  end

  # Avatar groupé (plusieurs utilisateurs)
  def grouped_avatars(users, max: 3)
    visible_users = users.take(max)
    remaining = [users.count - max, 0].max

    content_tag :div, class: "flex -space-x-2" do
      concat visible_users.map.with_index { |user, i|
        content_tag :div, class: "relative z-#{30 - i*10}" do
          user_avatar(user, size: 8)
        end
      }.join.html_safe

      if remaining > 0
        concat content_tag(:div, class: "relative z-0 w-8 h-8 rounded-full bg-muted border-2 border-card flex items-center justify-center") do
          content_tag :span, "+#{remaining}", class: "text-xs font-semibold text-muted-foreground"
        end
      end
    end
  end

  # Icône de notification enrichie
  def notification_icon(notification, options = {})
    icon_name = notification.icon
    color = notification.color
    size = options[:size] || 10

    icon_path = NOTIFICATION_ICONS[icon_name] || NOTIFICATION_ICONS['bell']
    color_classes = NOTIFICATION_COLORS[color] || NOTIFICATION_COLORS['gray']

    # Cas spécial pour les badges
    if notification.action == 'badge_earned' && notification.notifiable.is_a?(Badge)
      badge = notification.notifiable
      return content_tag :div, class: "w-#{size} h-#{size} rounded-full #{color_classes[:bg]} #{color_classes[:border]} border-2 flex items-center justify-center flex-shrink-0 shadow-sm" do
        content_tag :span, badge.icon, class: "text-2xl"
      end
    end

    content_tag :div, class: "w-#{size} h-#{size} rounded-full #{color_classes[:bg]} flex items-center justify-center flex-shrink-0 shadow-sm" do
      content_tag :svg, class: "w-#{size/2 + 1} h-#{size/2 + 1} #{color_classes[:text]}", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24" do
        raw icon_path
      end
    end
  end

  # Message enrichi de la notification
  def notification_message(notification)
    base_message = notification.message

    case notification.action
    when 'badge_earned'
      if notification.notifiable.is_a?(Badge)
        badge = notification.notifiable
        return content_tag(:span, class: "flex items-center gap-2") do
          concat content_tag(:span, "Tu as débloqué le badge", class: "text-muted-foreground")
          concat content_tag(:span, class: "font-bold text-foreground") do
            concat badge.icon + " "
            concat badge.name
          end
          if badge.description.present?
            concat content_tag(:span, " - #{badge.description}", class: "text-sm text-muted-foreground")
          end
        end
      end
    when 'skill_add', 'skill_level_up'
      if notification.metadata['skill_name']
        actors = notification.grouped_count > 1 ? notification.grouped_actors : [notification.actor]
        actor_names = actors.map(&:display_name).to_sentence

        return content_tag(:span) do
          concat content_tag(:span, actor_names, class: "font-semibold text-foreground")
          concat " "
          concat content_tag(:span, base_message, class: "text-muted-foreground")
          concat " : "
          concat content_tag(:span, notification.metadata['skill_name'], class: "font-medium text-primary")

          if notification.action == 'skill_level_up' && notification.metadata['new_level']
            concat " "
            concat content_tag(:span, "(#{notification.metadata['old_level']} → #{notification.metadata['new_level']})", class: "text-sm text-success")
          end
        end
      end
    end

    # Message par défaut avec groupement
    if notification.grouped_count && notification.grouped_count > 1
      actors = notification.grouped_actors.map(&:display_name)

      content_tag(:span) do
        concat content_tag(:span, actors.to_sentence, class: "font-semibold text-foreground")
        concat " "
        concat content_tag(:span, base_message, class: "text-muted-foreground")
      end
    else
      content_tag(:span) do
        if notification.actor
          concat content_tag(:span, notification.actor.display_name, class: "font-semibold text-foreground")
          concat " "
        end
        concat content_tag(:span, base_message, class: "text-muted-foreground")
      end
    end
  end

  # Classes CSS pour la carte de notification
  def notification_card_classes(notification)
    classes = [
      "group relative flex items-start gap-4 p-4 rounded-xl transition-all duration-200",
      "border border-border hover:border-primary/30",
      "hover:shadow-lg hover:scale-[1.01]",
      "cursor-pointer"
    ]

    unless notification.read?
      classes << "bg-primary/5"
      classes << "border-l-4 border-l-primary"
    else
      classes << "bg-card"
      classes << "opacity-75 hover:opacity-100"
    end

    classes.join(" ")
  end

  # Badge de notification non lue
  def notification_unread_badge
    content_tag :div, class: "w-2.5 h-2.5 bg-primary rounded-full flex-shrink-0 mt-2 shadow-sm shadow-primary/50 animate-pulse" do
    end
  end

  # Badge de groupement
  def notification_group_badge(count)
    return unless count && count > 1

    content_tag :span, count, class: "inline-flex items-center justify-center w-6 h-6 text-xs font-bold bg-primary text-primary-foreground rounded-full shadow-sm"
  end

  # Types de notifications avec leurs labels
  def notification_type_options
    NotificationPreference::NOTIFICATION_TYPES.map do |type|
      action_data = Notification::ACTIONS[type.to_sym]
      [
        action_data ? action_data[:message].capitalize : type.humanize,
        type
      ]
    end
  end

  # Filtre actif ?
  def notification_filter_active?(filter_type, current_filter)
    filter_type.to_s == current_filter.to_s
  end

  # Image d'aperçu pour certains types de notifications
  def notification_preview_image(notification)
    case notification.action
    when 'like', 'comment', 'comment_reply'
      if notification.notifiable.is_a?(Post) && notification.notifiable.image.attached?
        image_tag notification.notifiable.image.variant(resize_to_limit: [100, 100]),
                  class: "w-12 h-12 rounded-lg object-cover border border-border",
                  alt: "Aperçu"
      elsif notification.notifiable.is_a?(Comment) && notification.notifiable.post.image.attached?
        image_tag notification.notifiable.post.image.variant(resize_to_limit: [100, 100]),
                  class: "w-12 h-12 rounded-lg object-cover border border-border",
                  alt: "Aperçu"
      end
    end
  end
end
