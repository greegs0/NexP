# Service pour intégrer avec l'API GitLab
# Nécessite la gem 'gitlab' (à installer avec: bundle install)
#
# Configuration requise:
# - GITLAB_CLIENT_ID dans .env
# - GITLAB_CLIENT_SECRET dans .env
#
# Documentation: https://docs.gitlab.com/ee/api/

class GitlabIntegrationService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  # Récupérer le client GitLab avec le token de l'utilisateur
  def client
    raise "GitLab OAuth n'est pas configuré pour cet utilisateur" unless user.provider == 'gitlab' && user.oauth_token.present?

    # Décommenter quand la gem gitlab est installée:
    # @client ||= Gitlab.client(
    #   endpoint: 'https://gitlab.com/api/v4',
    #   private_token: user.oauth_token
    # )
    raise "Gem 'gitlab' non installée. Ajoutez gem 'gitlab' au Gemfile."
  end

  # Récupérer les projets de l'utilisateur
  def user_projects(limit: 10)
    projects = client.projects(owned: true, per_page: limit)

    projects.map do |project|
      {
        name: project.name,
        path: project.path_with_namespace,
        description: project.description,
        url: project.web_url,
        visibility: project.visibility,
        stars: project.star_count,
        forks: project.forks_count,
        open_issues: project.open_issues_count,
        created_at: project.created_at,
        last_activity_at: project.last_activity_at,
        topics: project.tag_list
      }
    end
  rescue => e
    Rails.logger.error "GitLab API Error: #{e.message}"
    []
  end

  # Récupérer les statistiques de l'utilisateur
  def user_stats
    gitlab_user = client.user

    {
      username: gitlab_user.username,
      name: gitlab_user.name,
      bio: gitlab_user.bio,
      location: gitlab_user.location,
      public_email: gitlab_user.public_email,
      website_url: gitlab_user.website_url,
      created_at: gitlab_user.created_at,
      state: gitlab_user.state
    }
  rescue => e
    Rails.logger.error "GitLab API Error: #{e.message}"
    {}
  end

  # Récupérer les événements récents
  def user_events(limit: 50)
    events = client.user_events(user.gitlab_username, per_page: limit)

    {
      total_events: events.size,
      by_type: events.group_by(&:action_name).transform_values(&:count),
      recent_activity: events.first(10).map do |event|
        {
          action: event.action_name,
          target_type: event.target_type,
          project: event.project_id,
          created_at: event.created_at
        }
      end
    }
  rescue => e
    Rails.logger.error "GitLab API Error: #{e.message}"
    {}
  end

  # Synchroniser les projets GitLab avec NexP
  def sync_projects_as_nexp_projects
    projects = user_projects(limit: 50)
    synced_count = 0

    projects.each do |project|
      # Vérifier si un projet existe déjà
      existing_project = user.owned_projects.find_by(title: project[:name])

      unless existing_project
        nexp_project = user.owned_projects.create(
          title: project[:name],
          description: project[:description] || "Importé depuis GitLab",
          status: 'in_progress',
          visibility: project[:visibility] == 'public' ? 'public' : 'private',
          gitlab_url: project[:url]
        )

        # Ajouter des skills basées sur les topics
        if project[:topics].present?
          project[:topics].each do |topic|
            skill = Skill.find_by('name ILIKE ?', topic)
            nexp_project.skills << skill if skill && !nexp_project.skills.include?(skill)
          end
        end

        synced_count += 1
      end
    end

    synced_count
  end

  # Méthodes de classe

  # Créer un utilisateur à partir des données OAuth GitLab
  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    if user
      # Mettre à jour le token
      user.update(
        oauth_token: auth.credentials.token,
        oauth_refresh_token: auth.credentials.refresh_token,
        oauth_expires_at: auth.credentials.expires_at ? Time.at(auth.credentials.expires_at) : nil
      )
    else
      # Créer un nouvel utilisateur
      user = User.create(
        provider: auth.provider,
        uid: auth.uid,
        gitlab_username: auth.info.username,
        email: auth.info.email || "#{auth.info.username}@gitlab-oauth.local",
        username: auth.info.username,
        name: auth.info.name,
        bio: auth.extra.raw_info.bio,
        avatar_url: auth.info.image,
        oauth_token: auth.credentials.token,
        oauth_refresh_token: auth.credentials.refresh_token,
        oauth_expires_at: auth.credentials.expires_at ? Time.at(auth.credentials.expires_at) : nil,
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end
end
