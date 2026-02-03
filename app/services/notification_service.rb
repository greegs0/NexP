class NotificationService
  # Délai pour grouper les notifications similaires (en secondes)
  GROUPING_WINDOW = 5.minutes

  class << self
    # Méthode principale pour créer une notification
    # @param user [User] L'utilisateur qui recevra la notification
    # @param action [Symbol/String] Le type de notification
    # @param actor [User] L'utilisateur qui effectue l'action
    # @param notifiable [ActiveRecord] L'objet concerné (Post, Comment, etc.)
    # @param url [String] URL vers la ressource
    # @param metadata [Hash] Données supplémentaires
    def notify(user:, action:, actor: nil, notifiable: nil, url: nil, metadata: {})
      return unless should_notify?(user, action)

      action = action.to_s

      # Tentative de groupement si l'action est groupable
      if groupable?(action)
        existing = find_groupable_notification(user, action, notifiable)

        if existing
          update_grouped_notification(existing, actor)
          broadcast_notification(existing)
          return existing
        end
      end

      # Créer une nouvelle notification
      notification = Notification.create!(
        user: user,
        actor: actor,
        notifiable: notifiable,
        action: action,
        url: url || generate_url(notifiable),
        metadata: metadata.merge(actor_ids: actor ? [actor.id] : [])
      )

      # Broadcaster en temps réel via ActionCable
      broadcast_notification(notification)

      notification
    end

    # Notifications de likes
    def notify_like(post:, liker:)
      notify(
        user: post.user,
        action: :like,
        actor: liker,
        notifiable: post,
        url: Rails.application.routes.url_helpers.post_path(post)
      )
    end

    # Notifications de commentaires
    def notify_comment(comment:)
      # Notifier l'auteur du post
      if comment.post.user != comment.user
        notify(
          user: comment.post.user,
          action: :comment,
          actor: comment.user,
          notifiable: comment,
          url: Rails.application.routes.url_helpers.post_path(comment.post, anchor: "comment-#{comment.id}")
        )
      end

      # Notifier l'auteur du commentaire parent si c'est une réponse
      if comment.parent && comment.parent.user != comment.user
        notify(
          user: comment.parent.user,
          action: :comment_reply,
          actor: comment.user,
          notifiable: comment,
          url: Rails.application.routes.url_helpers.post_path(comment.post, anchor: "comment-#{comment.id}")
        )
      end
    end

    # Notifications de follow
    def notify_follow(follower:, following:)
      notify(
        user: following,
        action: :follow,
        actor: follower,
        notifiable: Follow.find_by(follower: follower, following: following),
        url: Rails.application.routes.url_helpers.user_path(follower)
      )
    end

    # Notifications de mention
    def notify_mention(mentioned_user:, mentioner:, content:)
      type = content.is_a?(Post) ? :post_mention : :mention

      notify(
        user: mentioned_user,
        action: type,
        actor: mentioner,
        notifiable: content,
        url: generate_url(content)
      )
    end

    # Notifications de projet
    def notify_project_join(project:, joiner:)
      notify(
        user: project.owner,
        action: :project_join,
        actor: joiner,
        notifiable: project,
        url: Rails.application.routes.url_helpers.project_path(project)
      )
    end

    def notify_project_invite(project:, inviter:, invitee:)
      notify(
        user: invitee,
        action: :project_invite,
        actor: inviter,
        notifiable: project,
        url: Rails.application.routes.url_helpers.project_path(project),
        metadata: { project_name: project.name }
      )
    end

    # Notifications de compétences
    def notify_skill_add(user_skill:)
      # Notifier les followers
      user_skill.user.followers.find_each do |follower|
        notify(
          user: follower,
          action: :skill_add,
          actor: user_skill.user,
          notifiable: user_skill,
          url: Rails.application.routes.url_helpers.user_path(user_skill.user),
          metadata: { skill_name: user_skill.skill.name }
        )
      end
    end

    def notify_skill_level_up(user_skill:, old_level:, new_level:)
      # Notifier les followers
      user_skill.user.followers.find_each do |follower|
        notify(
          user: follower,
          action: :skill_level_up,
          actor: user_skill.user,
          notifiable: user_skill,
          url: Rails.application.routes.url_helpers.user_path(user_skill.user),
          metadata: {
            skill_name: user_skill.skill.name,
            old_level: old_level,
            new_level: new_level
          }
        )
      end
    end

    # Notification de badge
    def notify_badge_earned(user:, badge:)
      notify(
        user: user,
        action: :badge_earned,
        actor: nil,
        notifiable: badge,
        url: Rails.application.routes.url_helpers.user_path(user),
        metadata: {
          badge_name: badge.name,
          badge_icon: badge.icon,
          badge_description: badge.description
        }
      )
    end

    # Notification de message
    def notify_message(message:)
      notify(
        user: message.recipient,
        action: :message,
        actor: message.sender,
        notifiable: message,
        url: Rails.application.routes.url_helpers.conversation_path(message.conversation)
      )
    end

    # Marquer toutes les notifications comme lues
    def mark_all_as_read(user)
      Notification.mark_all_as_read(user)
    end

    # Marquer une sélection comme lue
    def mark_as_read(notification_ids, user)
      user.notifications.where(id: notification_ids).update_all(read: true, updated_at: Time.current)
    end

    # Supprimer des notifications
    def delete_notifications(notification_ids, user)
      user.notifications.where(id: notification_ids).destroy_all
    end

    private

    # Vérifier si l'utilisateur veut recevoir ce type de notification
    def should_notify?(user, action)
      return false if user.nil?
      NotificationPreference.enabled_for?(user, action.to_s)
    end

    # Vérifier si une action est groupable
    def groupable?(action)
      Notification::ACTIONS.dig(action.to_sym, :groupable) || false
    end

    # Trouver une notification similaire récente pour grouper
    def find_groupable_notification(user, action, notifiable)
      return nil unless notifiable

      user.notifications
        .where(action: action)
        .where(notifiable: notifiable)
        .where('created_at > ?', GROUPING_WINDOW.ago)
        .order(created_at: :desc)
        .first
    end

    # Mettre à jour une notification groupée
    def update_grouped_notification(notification, new_actor)
      return unless new_actor

      actor_ids = (notification.metadata['actor_ids'] || []).push(new_actor.id).uniq

      notification.update!(
        actor: new_actor, # Le dernier acteur
        grouped_count: actor_ids.size,
        metadata: notification.metadata.merge('actor_ids' => actor_ids),
        read: false, # Marquer comme non-lue
        updated_at: Time.current
      )
    end

    # Générer l'URL basée sur le type d'objet
    def generate_url(notifiable)
      return nil unless notifiable

      case notifiable
      when Post
        Rails.application.routes.url_helpers.post_path(notifiable)
      when Comment
        Rails.application.routes.url_helpers.post_path(notifiable.post, anchor: "comment-#{notifiable.id}")
      when Project
        Rails.application.routes.url_helpers.project_path(notifiable)
      when User
        Rails.application.routes.url_helpers.user_path(notifiable)
      when UserSkill
        Rails.application.routes.url_helpers.user_path(notifiable.user)
      when Message
        Rails.application.routes.url_helpers.conversation_path(notifiable.conversation) if notifiable.conversation
      else
        nil
      end
    rescue
      nil
    end

    # Broadcaster la notification via ActionCable
    def broadcast_notification(notification)
      NotificationChannel.broadcast_to(
        notification.user,
        {
          id: notification.id,
          message: notification.message,
          actor_name: notification.actor&.display_name || 'Système',
          actor_avatar: notification.actor&.display_name&.first&.upcase || 'S',
          icon: notification.icon,
          color: notification.color,
          url: notification.url,
          time_ago: notification.time_ago,
          read: notification.read?,
          grouped_count: notification.grouped_count,
          unread_count: notification.user.notifications.unread.count
        }
      )
    end
  end
end
