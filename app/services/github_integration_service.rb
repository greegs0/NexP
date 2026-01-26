# Service pour intégrer avec l'API GitHub
# Nécessite la gem 'octokit' (à installer avec: bundle install)
#
# Configuration requise:
# - GITHUB_CLIENT_ID dans .env
# - GITHUB_CLIENT_SECRET dans .env
#
# Documentation: https://docs.github.com/en/rest

class GithubIntegrationService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  # Récupérer le client GitHub avec le token de l'utilisateur
  def client
    raise "GitHub OAuth n'est pas configuré pour cet utilisateur" unless user.provider == 'github' && user.oauth_token.present?

    # Décommenter quand octokit est installé:
    # @client ||= Octokit::Client.new(access_token: user.oauth_token)
    raise "Gem 'octokit' non installée. Ajoutez gem 'octokit' au Gemfile."
  end

  # Récupérer les repositories publics de l'utilisateur
  def user_repositories(limit: 10)
    repos = client.repositories(user.github_username, per_page: limit)

    repos.map do |repo|
      {
        name: repo.name,
        full_name: repo.full_name,
        description: repo.description,
        url: repo.html_url,
        language: repo.language,
        stars: repo.stargazers_count,
        forks: repo.forks_count,
        open_issues: repo.open_issues_count,
        created_at: repo.created_at,
        updated_at: repo.updated_at,
        topics: repo.topics
      }
    end
  rescue => e
    Rails.logger.error "GitHub API Error: #{e.message}"
    []
  end

  # Récupérer les contributions récentes
  def user_contributions
    events = client.user_events(user.github_username, per_page: 100)

    {
      total_events: events.size,
      push_events: events.count { |e| e.type == 'PushEvent' },
      pull_request_events: events.count { |e| e.type == 'PullRequestEvent' },
      issue_events: events.count { |e| e.type == 'IssuesEvent' },
      recent_activity: events.first(10).map do |event|
        {
          type: event.type,
          repo: event.repo.name,
          created_at: event.created_at
        }
      end
    }
  rescue => e
    Rails.logger.error "GitHub API Error: #{e.message}"
    {}
  end

  # Récupérer les statistiques de l'utilisateur
  def user_stats
    github_user = client.user(user.github_username)

    {
      login: github_user.login,
      name: github_user.name,
      bio: github_user.bio,
      location: github_user.location,
      public_repos: github_user.public_repos,
      public_gists: github_user.public_gists,
      followers: github_user.followers,
      following: github_user.following,
      created_at: github_user.created_at,
      updated_at: github_user.updated_at
    }
  rescue => e
    Rails.logger.error "GitHub API Error: #{e.message}"
    {}
  end

  # Synchroniser les projets GitHub avec NexP
  def sync_repositories_as_projects
    repos = user_repositories(limit: 50)
    synced_count = 0

    repos.each do |repo|
      # Vérifier si un projet existe déjà avec le même nom
      existing_project = user.owned_projects.find_by(title: repo[:name])

      unless existing_project
        project = user.owned_projects.create(
          title: repo[:name],
          description: repo[:description] || "Importé depuis GitHub",
          status: 'in_progress',
          visibility: 'public',
          github_url: repo[:url]
        )

        # Ajouter des skills basées sur le langage
        if repo[:language].present?
          skill = Skill.find_by('name ILIKE ?', repo[:language])
          project.skills << skill if skill
        end

        synced_count += 1
      end
    end

    synced_count
  end

  # Méthodes de classe

  # Créer un utilisateur à partir des données OAuth GitHub
  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)

    if user
      # Mettre à jour le token
      user.update(
        oauth_token: auth.credentials.token,
        oauth_expires_at: auth.credentials.expires_at ? Time.at(auth.credentials.expires_at) : nil
      )
    else
      # Créer un nouvel utilisateur
      user = User.create(
        provider: auth.provider,
        uid: auth.uid,
        github_username: auth.info.nickname,
        email: auth.info.email || "#{auth.info.nickname}@github-oauth.local",
        username: auth.info.nickname,
        name: auth.info.name,
        bio: auth.info.description,
        avatar_url: auth.info.image,
        github_url: auth.info.urls.GitHub,
        oauth_token: auth.credentials.token,
        oauth_expires_at: auth.credentials.expires_at ? Time.at(auth.credentials.expires_at) : nil,
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end
end
