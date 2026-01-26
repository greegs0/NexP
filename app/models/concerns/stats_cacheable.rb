module StatsCacheable
  extend ActiveSupport::Concern

  included do
    # Invalider les caches de stats quand l'utilisateur est modifié
    after_save :expire_stats_cache
  end

  # Cache les statistiques de l'utilisateur
  def cached_stats
    Rails.cache.fetch("user/#{id}/stats", expires_in: 5.minutes) do
      {
        posts_count: posts_count,
        followers_count: followers_count,
        following_count: following_count,
        owned_projects_count: owned_projects_count,
        participated_projects_count: teams.accepted.count,
        total_projects_count: owned_projects_count + teams.accepted.count,
        level: level,
        experience_points: experience_points,
        skills_count: skills.count,
        badges_count: badges.count
      }
    end
  end

  # Cache le nombre de notifications non lues
  def cached_unread_notifications_count
    Rails.cache.fetch("user/#{id}/unread_notifications", expires_in: 30.seconds) do
      notifications.where(read: false).count
    end
  end

  # Cache les messages non lus
  def cached_unread_messages_count
    Rails.cache.fetch("user/#{id}/unread_messages", expires_in: 30.seconds) do
      received_messages.unread.count
    end
  end

  def expire_stats_cache
    Rails.cache.delete("user/#{id}/stats")
    Rails.cache.delete("user/#{id}/unread_notifications")
    Rails.cache.delete("user/#{id}/unread_messages")
  end
end
