class SkillsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Catégories disponibles
    @categories = Skill::CATEGORIES
    @current_category = params[:category]

    # Skills de l'utilisateur
    @user_skills = current_user.user_skills.includes(:skill)

    # Skills disponibles (pas encore ajoutées par l'user)
    @available_skills = Skill.where.not(id: current_user.skills.pluck(:id))

    # Filtres
    @available_skills = @available_skills.by_category(params[:category]) if params[:category].present?
    @available_skills = @available_skills.search(params[:search]) if params[:search].present?

    # Grouper par catégorie
    @skills_by_category = @available_skills.order(:category, :name).group_by(&:category)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("available_skills", partial: "skills/available_skills", locals: { skills_by_category: @skills_by_category })
      end
    end
  end

  def show
    @skill = Skill.find(params[:id])
    @users = @skill.users.includes(:user_skills)
    @projects = @skill.projects.includes(:owner, :skills)
  rescue ActiveRecord::RecordNotFound
    redirect_to skills_path, alert: "Cette compétence n'existe pas."
  end
end
