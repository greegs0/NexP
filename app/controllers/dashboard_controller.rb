class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    # Stats optimisées
    @total_skills = current_user.skills.count
    @total_projects = current_user.projects.count
    @total_owned_projects = current_user.owned_projects.count
    @total_badges = current_user.badges.count

    # Projets récents avec optimisation N+1
    @recent_projects = current_user.projects
                                   .includes(:owner, :skills)
                                   .order(created_at: :desc)
                                   .limit(3)

    # Projets créés par l'utilisateur
    @owned_projects = current_user.owned_projects
                                  .includes(:skills, :members)
                                  .order(created_at: :desc)
                                  .limit(3)

    # Skills récentes
    @recent_skills = current_user.skills
                                 .order('user_skills.created_at DESC')
                                 .limit(5)
  end
end
