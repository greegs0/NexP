class MatchingService
  # Trouve les meilleurs projets pour un utilisateur
  def self.find_projects_for_user(user, limit: 10)
    return [] if user.skills.empty?

    # Récupérer tous les projets disponibles
    available_projects = Project.includes(:skills, :owner, :members)
                                .where(visibility: 'public')
                                .where(status: ['open', 'in_progress'])
                                .where('current_members_count < max_members')
                                .where.not(owner_id: user.id)

    # Exclure les projets où l'utilisateur est déjà membre
    user_project_ids = user.projects.pluck(:id)
    available_projects = available_projects.where.not(id: user_project_ids)

    # Calculer le score pour chaque projet
    scored_projects = available_projects.map do |project|
      score = calculate_project_match_score(user, project)
      { project: project, score: score }
    end

    # Trier par score et retourner les meilleurs
    scored_projects.sort_by { |sp| -sp[:score] }
                   .first(limit)
                   .map { |sp| sp[:project] }
  end

  # Trouve les meilleurs développeurs pour un projet
  def self.find_users_for_project(project, limit: 10)
    return [] if project.skills.empty?

    # Récupérer les utilisateurs disponibles
    available_users = User.includes(:skills)
                          .where(available: true)
                          .where.not(id: project.owner_id)

    # Exclure les membres déjà dans le projet
    member_ids = project.members.pluck(:id)
    available_users = available_users.where.not(id: member_ids)

    # Calculer le score pour chaque utilisateur
    scored_users = available_users.map do |user|
      score = calculate_user_match_score(user, project)
      { user: user, score: score }
    end

    # Trier par score et retourner les meilleurs
    scored_users.sort_by { |su| -su[:score] }
                .first(limit)
                .map { |su| su[:user] }
  end

  # Trouve des utilisateurs similaires (pour suggestions de follow)
  def self.find_similar_users(user, limit: 10)
    return [] if user.skills.empty?

    user_skill_ids = user.skills.pluck(:id)

    # Trouver des utilisateurs avec des compétences similaires
    similar_users = User.joins(:user_skills)
                        .where(user_skills: { skill_id: user_skill_ids })
                        .where.not(id: user.id)
                        .select('users.*, COUNT(user_skills.skill_id) as common_skills_count')
                        .group('users.id')
                        .order('common_skills_count DESC')
                        .limit(limit)

    similar_users
  end

  private

  # Calcule le score de matching entre un utilisateur et un projet
  def self.calculate_project_match_score(user, project)
    score = 0.0

    user_skill_ids = user.skills.pluck(:id)
    project_skill_ids = project.skills.pluck(:id)

    # 1. Score basé sur les compétences communes (max 50 points)
    common_skills = (user_skill_ids & project_skill_ids).size
    total_project_skills = project_skill_ids.size

    if total_project_skills > 0
      skills_match_ratio = common_skills.to_f / total_project_skills
      score += skills_match_ratio * 50
    end

    # 2. Score basé sur le niveau de l'utilisateur (max 20 points)
    # Plus le niveau est élevé, plus le score est élevé
    score += (user.level.to_f / 100) * 20

    # 3. Bonus si le projet vient de commencer (max 15 points)
    if project.status == 'open'
      score += 15
    elsif project.status == 'in_progress'
      score += 10
    end

    # 4. Bonus si le projet a peu de membres (max 10 points)
    vacancy_ratio = (project.max_members - project.current_members_count).to_f / project.max_members
    score += vacancy_ratio * 10

    # 5. Pénalité si le projet a beaucoup de compétences manquantes
    missing_skills = project_skill_ids.size - common_skills
    if missing_skills > 3
      score -= (missing_skills - 3) * 2
    end

    # 6. Bonus si l'utilisateur a plus de compétences que nécessaire (polyvalence)
    extra_skills = user_skill_ids.size - project_skill_ids.size
    if extra_skills > 0
      score += [extra_skills * 0.5, 5].min
    end

    [score, 0].max # S'assurer que le score n'est pas négatif
  end

  # Calcule le score de matching entre un projet et un utilisateur
  def self.calculate_user_match_score(user, project)
    score = 0.0

    user_skill_ids = user.skills.pluck(:id)
    project_skill_ids = project.skills.pluck(:id)

    # 1. Score basé sur les compétences communes (max 50 points)
    common_skills = (user_skill_ids & project_skill_ids).size
    total_project_skills = project_skill_ids.size

    if total_project_skills > 0
      skills_match_ratio = common_skills.to_f / total_project_skills
      score += skills_match_ratio * 50
    end

    # 2. Score basé sur le niveau (max 20 points)
    score += (user.level.to_f / 100) * 20

    # 3. Bonus si l'utilisateur est disponible (max 10 points)
    score += 10 if user.available

    # 4. Bonus basé sur l'expérience (max 10 points)
    score += [user.experience_points.to_f / 1000, 10].min

    # 5. Bonus basé sur le nombre de projets complétés (max 10 points)
    completed_projects = user.projects.where(status: 'completed').count + user.owned_projects.where(status: 'completed').count
    score += [completed_projects * 2, 10].min

    [score, 0].max
  end
end
