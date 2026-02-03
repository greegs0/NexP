# frozen_string_literal: true

# Service pour vérifier et attribuer les badges aux utilisateurs
#
# Usage:
#   BadgeService.check_and_award_badges(user)
#
class BadgeService
  # Définitions des badges avec leur critère et description
  BADGE_DEFINITIONS = {
    # Badges de niveau
    level: {
      'Débutant' => { threshold: 1, description: "Bienvenue! Tu viens de rejoindre la communauté." },
      'Apprenti' => { threshold: 5, description: "Niveau 5 atteint. Tu progresses bien!" },
      'Intermédiaire' => { threshold: 10, description: "Niveau 10! Tu maîtrises les bases de la plateforme." },
      'Avancé' => { threshold: 20, description: "Niveau 20. Tu es un membre avancé et expérimenté." },
      'Expert' => { threshold: 30, description: "Niveau 30! Ton expertise est reconnue par tous." },
      'Maître' => { threshold: 50, description: "Niveau 50. Tu es un maître incontesté!" },
      'Légende' => { threshold: 100, description: "Niveau 100! Tu es une légende vivante de la plateforme." }
    },

    # Badges de projets créés
    owned_projects: {
      'Premier Projet' => { threshold: 1, description: "Tu as créé ton premier projet. C'est le début de l'aventure!" },
      'Entrepreneur' => { threshold: 5, description: "5 projets créés! Tu as l'âme d'un entrepreneur." },
      'Chef de Projet' => { threshold: 10, description: "10 projets à ton actif. Tu es un vrai chef de projet!" }
    },

    # Badges de participation
    projects: {
      'Collaborateur' => { threshold: 5, description: "Tu as participé à 5 projets. L'esprit d'équipe te définit." },
      'Team Player' => { threshold: 10, description: "10 projets en collaboration. Tu es un joueur d'équipe exemplaire!" }
    },

    # Badges sociaux - posts
    posts: {
      'Première Publication' => { threshold: 1, description: "Tu as publié ton premier post. Ta voix compte!" },
      'Blogueur' => { threshold: 10, description: "10 publications! Tu partages régulièrement tes idées." },
      'Influenceur' => { threshold: 50, description: "50 posts publiés. Tu es une vraie source d'inspiration!" }
    },

    # Badges sociaux - commentaires
    comments: {
      'Commentateur' => { threshold: 20, description: "20 commentaires laissés. Tu aimes participer aux discussions." }
    },

    # Badges sociaux - followers
    followers: {
      'Populaire' => { threshold: 10, description: "10 personnes te suivent. Ta communauté grandit!" },
      'Célébrité' => { threshold: 50, description: "50 followers! Tu es une célébrité sur la plateforme." }
    },

    # Badges sociaux - following
    following: {
      'Social' => { threshold: 10, description: "Tu suis 10 personnes. Tu aimes découvrir de nouveaux profils." }
    },

    # Badges de compétences
    skills: {
      'Polyvalent' => { threshold: 5, description: "5 compétences ajoutées. Tu es polyvalent et curieux!" },
      'Expert Multi-Domaines' => { threshold: 10, description: "10 compétences maîtrisées. Un vrai couteau suisse!" }
    },

    # Badges de messages
    sent_messages: {
      'Communicateur' => { threshold: 50, description: "50 messages envoyés. Tu aimes échanger avec les autres." },
      'Bavard' => { threshold: 200, description: "200 messages! La communication n'a pas de secret pour toi." }
    }
  }.freeze

  def self.check_and_award_badges(user)
    new(user).check_and_award_badges
  end

  def initialize(user)
    @user = user
    @user_stats = calculate_user_stats
  end

  def check_and_award_badges
    BADGE_DEFINITIONS.each do |stat_key, badges|
      check_badges_for_stat(stat_key, badges)
    end
  end

  private

  def calculate_user_stats
    # Utilise les counter_cache quand disponibles pour éviter les N+1 queries
    {
      level: @user.level,
      owned_projects: @user.owned_projects_count,    # counter_cache
      projects: @user.projects.count,                 # pas de counter_cache
      posts: @user.posts_count,                       # counter_cache
      comments: @user.comments.count,                 # pas de counter_cache
      followers: @user.followers_count,               # counter_cache
      following: @user.following_count,               # counter_cache
      skills: @user.skills.count,                     # pas de counter_cache
      sent_messages: @user.sent_messages.count        # pas de counter_cache
    }
  end

  def check_badges_for_stat(stat_key, badges)
    current_value = @user_stats[stat_key]
    return unless current_value

    badges.each do |name, config|
      next unless current_value >= config[:threshold]

      badge = find_or_create_badge(name, config[:description], stat_key, config[:threshold])
      award_badge(badge)
    end
  end

  def find_or_create_badge(name, description, stat_key, threshold)
    badge = Badge.find_or_initialize_by(name: name)
    badge.description = description
    badge.xp_required = calculate_xp_required(stat_key, threshold) if badge.respond_to?(:xp_required=)
    badge.save!
    badge
  end

  def calculate_xp_required(stat_key, threshold)
    return (threshold - 1) * 100 if stat_key == :level
    0
  end

  def award_badge(badge)
    return if @user.badges.include?(badge)

    @user.user_badges.create(
      badge: badge,
      earned_at: Time.current
    )

    create_badge_notification(badge)
  end

  def create_badge_notification(badge)
    Notification.create(
      user: @user,
      actor: @user,
      notifiable: badge,
      action: 'badge_earned'
    )
  end
end
