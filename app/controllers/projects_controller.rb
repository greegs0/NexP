class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @projects = Project.includes(:owner, :skills, :members)
                       .where(visibility: 'public')
                       .order(created_at: :desc)

    # Filtres optionnels
    @projects = @projects.where(status: params[:status]) if params[:status].present?
    @projects = @projects.joins(:skills).where(skills: { id: params[:skill_id] }) if params[:skill_id].present?

    @projects = @projects.distinct.page(params[:page]).per(12)
  end

  def show
    @team_members = @project.members.includes(:skills)
    @project_skills = @project.skills
    @is_member = @project.members.include?(current_user)
    @is_owner = @project.owner == current_user
  end

  def new
    @project = current_user.owned_projects.build
    @available_skills = Skill.order(:category, :name)
  end

  def create
    @project = current_user.owned_projects.build(project_params)

    if @project.save
      # Ajouter les skills au projet
      if params[:project][:skill_ids].present?
        skill_ids = params[:project][:skill_ids].reject(&:blank?)
        @project.skill_ids = skill_ids
      end

      redirect_to @project, notice: 'Projet créé avec succès.'
    else
      @available_skills = Skill.order(:category, :name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_skills = Skill.order(:category, :name)
  end

  def update
    if @project.update(project_params)
      # Mettre à jour les skills
      if params[:project][:skill_ids].present?
        skill_ids = params[:project][:skill_ids].reject(&:blank?)
        @project.skill_ids = skill_ids
      end

      redirect_to @project, notice: 'Projet mis à jour avec succès.'
    else
      @available_skills = Skill.order(:category, :name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Projet supprimé avec succès.'
  end

  def join
    if @project.members.include?(current_user)
      redirect_to @project, alert: 'Vous êtes déjà membre de ce projet.'
      return
    end

    if @project.current_members_count >= @project.max_members
      redirect_to @project, alert: 'Ce projet est complet.'
      return
    end

    @team = @project.teams.build(
      user: current_user,
      role: 'member',
      status: 'accepted',
      joined_at: Time.current
    )

    if @team.save
      @project.increment!(:current_members_count)
      redirect_to @project, notice: 'Vous avez rejoint le projet.'
    else
      redirect_to @project, alert: "Erreur : #{@team.errors.full_messages.join(', ')}"
    end
  end

  def leave
    @team = @project.teams.find_by(user: current_user)

    unless @team
      redirect_to @project, alert: 'Vous ne faites pas partie de ce projet.'
      return
    end

    if @project.owner == current_user
      redirect_to @project, alert: 'Le créateur ne peut pas quitter son propre projet.'
      return
    end

    if @team.destroy
      @project.decrement!(:current_members_count)
      redirect_to projects_path, notice: 'Vous avez quitté le projet.'
    else
      redirect_to @project, alert: 'Impossible de quitter le projet.'
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Ce projet n'existe pas."
  end

  def authorize_owner!
    unless @project.owner == current_user
      redirect_to @project, alert: "Vous n'êtes pas autorisé à modifier ce projet."
    end
  end

  def project_params
    params.require(:project).permit(
      :title,
      :description,
      :status,
      :visibility,
      :max_members,
      :start_date,
      :end_date,
      :deadline
    )
  end
end
