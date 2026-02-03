# frozen_string_literal: true

# Service centralisé pour l'attribution d'XP et la création de notifications
#
# Usage:
#   ExperienceService.award(user: current_user, action: :post_created)
#   ExperienceService.award(user: current_user, action: :like_given, target_user: post.user, notifiable: post)
#
class ExperienceService
  # Valeurs XP par action
  XP_VALUES = {
    # Actions de création
    post_created: 10,
    comment_created: 5,
    message_sent: 3,

    # Actions sociales
    follow_given: 5,
    like_given: 2,

    # XP reçu par l'auteur
    comment_received: 3,
    like_received: 5
  }.freeze

  # Mapping action -> notification action
  NOTIFICATION_ACTIONS = {
    follow_given: 'follow',
    like_given: 'like',
    comment_created: 'comment',
    message_sent: 'message'
  }.freeze

  class << self
    # Point d'entrée principal
    #
    # @param user [User] L'utilisateur qui reçoit l'XP
    # @param action [Symbol] L'action effectuée (ex: :post_created, :like_given)
    # @param target_user [User, nil] L'utilisateur cible pour les notifications
    # @param notifiable [ApplicationRecord, nil] L'objet lié à la notification
    # @return [Boolean] true si l'XP a été attribué
    def award(user:, action:, target_user: nil, notifiable: nil)
      new(user).award(action, target_user: target_user, notifiable: notifiable)
    end

    # Attribue l'XP pour une action avec notification au destinataire
    #
    # @param actor [User] L'utilisateur qui fait l'action
    # @param action [Symbol] L'action effectuée
    # @param target_user [User] L'utilisateur cible
    # @param notifiable [ApplicationRecord] L'objet lié
    def award_with_notification(actor:, action:, target_user:, notifiable:)
      # XP pour l'acteur
      award(user: actor, action: action)

      # XP pour le destinataire (si différent)
      if target_user && target_user != actor
        received_action = "#{action.to_s.gsub('_given', '')}_received".to_sym
        award(user: target_user, action: received_action) if XP_VALUES.key?(received_action)

        # Notification
        create_notification(
          user: target_user,
          actor: actor,
          notifiable: notifiable,
          action: action
        )
      end
    end

    private

    def create_notification(user:, actor:, notifiable:, action:)
      notification_action = NOTIFICATION_ACTIONS[action]
      return unless notification_action

      Notification.create(
        user: user,
        actor: actor,
        notifiable: notifiable,
        action: notification_action
      )
    end
  end

  def initialize(user)
    @user = user
  end

  def award(action, target_user: nil, notifiable: nil)
    xp_amount = XP_VALUES[action.to_sym]
    return false unless xp_amount

    @user.add_experience(xp_amount)
    true
  end
end
