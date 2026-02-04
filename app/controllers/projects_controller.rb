class ProjectsController < ApplicationController
  include Authorizable
  include PlanLimits

  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy, :join, :leave]
  before_action -> { authorize_owner!(@project) }, only: [:edit, :update, :destroy]
  before_action :check_project_limit!, only: [:create]

  def index
    @projects = Project.includes(:owner, :skills, :members)
                       .where(visibility: 'public')
                       .order(created_at: :desc)

    # Filtres optionnels
    @projects = @projects.where(status: params[:status]) if params[:status].present?
    @projects = @projects.joins(:skills).where(skills: { id: params[:skill_id] }) if params[:skill_id].present?
    @projects = @projects.where("title ILIKE ?", "%#{params[:search]}%") if params[:search].present?

    @projects = @projects.distinct.page(params[:page]).per(12)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("projects_results", partial: "projects/results", locals: { projects: @projects })
      end
    end
  end

  def show
    @team_members = @project.members.includes(:skills)
    @project_skills = @project.skills
    @membership_service = ProjectMembershipService.new(@project, current_user)
    @is_member = @membership_service.member?
    @is_owner = @membership_service.owner?
  end

  def new
    @project = current_user.owned_projects.build
    @available_skills = Skill.all_cached
  end

  def create
    @project = current_user.owned_projects.build(project_params)

    if @project.save
      assign_project_skills
      redirect_to @project, notice: 'Projet créé avec succès.'
    else
      @available_skills = Skill.all_cached
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_skills = Skill.all_cached
  end

  def update
    if @project.update(project_params)
      assign_project_skills
      redirect_to @project, notice: 'Projet mis à jour avec succès.'
    else
      @available_skills = Skill.all_cached
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Projet supprimé avec succès.'
  end

  def join
    service = ProjectMembershipService.new(@project, current_user)
    service.join
    redirect_to @project, notice: 'Vous avez rejoint le projet.'
  rescue ProjectMembershipService::AlreadyMemberError => e
    redirect_to @project, alert: e.message
  rescue ProjectMembershipService::ProjectFullError => e
    redirect_to @project, alert: e.message
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    redirect_to @project, alert: "Impossible de rejoindre le projet."
  end

  def leave
    service = ProjectMembershipService.new(@project, current_user)
    service.leave
    redirect_to projects_path, notice: 'Vous avez quitté le projet.'
  rescue ProjectMembershipService::NotMemberError => e
    redirect_to @project, alert: e.message
  rescue ProjectMembershipService::OwnerCannotLeaveError => e
    redirect_to @project, alert: e.message
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to @project, alert: 'Impossible de quitter le projet.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def assign_project_skills
    return unless params[:project][:skill_ids].present?

    skill_ids = params[:project][:skill_ids].reject(&:blank?)
    @project.skill_ids = skill_ids
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
