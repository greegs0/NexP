module Api
  module V1
    class ProjectsController < BaseController
      before_action :set_project, only: [:show, :update, :destroy, :join, :leave]
      skip_before_action :authenticate_api_user!, only: [:index, :show]

      # GET /api/v1/projects
      def index
        @projects = Project.includes(:owner, :skills, :members).where(visibility: 'public')

        # Filtres
        @projects = @projects.where(status: params[:status]) if params[:status].present?
        @projects = @projects.joins(:skills).where(skills: { id: params[:skill_id] }) if params[:skill_id].present?
        @projects = @projects.where("title ILIKE ?", "%#{params[:search]}%") if params[:search].present?
        @projects = @projects.available if params[:available] == 'true'

        @projects = @projects.distinct.order(created_at: :desc).page(params[:page]).per(params[:per_page] || 20)

        render json: {
          projects: @projects.map { |p| project_summary_json(p) },
          meta: pagination_meta(@projects)
        }
      end

      # GET /api/v1/projects/:id
      def show
        render json: {
          project: project_detail_json(@project)
        }
      end

      # POST /api/v1/projects
      def create
        @project = current_api_user.owned_projects.build(project_params)

        if @project.save
          # Ajouter les skills
          @project.skill_ids = params[:skill_ids] if params[:skill_ids].present?

          render json: { project: project_detail_json(@project) }, status: :created
        else
          render json: { error: 'Création échouée', details: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/projects/:id
      def update
        unless @project.owner == current_api_user
          render json: { error: 'Non autorisé' }, status: :forbidden
          return
        end

        if @project.update(project_params)
          @project.skill_ids = params[:skill_ids] if params[:skill_ids].present?
          render json: { project: project_detail_json(@project) }
        else
          render json: { error: 'Mise à jour échouée', details: @project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/projects/:id
      def destroy
        unless @project.owner == current_api_user
          render json: { error: 'Non autorisé' }, status: :forbidden
          return
        end

        @project.destroy
        render json: { message: 'Projet supprimé avec succès' }
      end

      # POST /api/v1/projects/:id/join
      def join
        if @project.members.include?(current_api_user)
          render json: { error: 'Vous êtes déjà membre de ce projet' }, status: :unprocessable_entity
          return
        end

        if @project.full?
          render json: { error: 'Ce projet est complet' }, status: :unprocessable_entity
          return
        end

        Project.transaction do
          @project.lock!

          if @project.full?
            render json: { error: 'Ce projet est complet' }, status: :unprocessable_entity
            return
          end

          team = @project.teams.create!(
            user: current_api_user,
            role: 'member',
            status: 'accepted',
            joined_at: Time.current
          )

          @project.increment!(:current_members_count)
        end

        render json: { message: 'Vous avez rejoint le projet' }
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        render json: { error: 'Impossible de rejoindre le projet' }, status: :unprocessable_entity
      end

      # DELETE /api/v1/projects/:id/leave
      def leave
        team = @project.teams.find_by(user: current_api_user)

        unless team
          render json: { error: 'Vous ne faites pas partie de ce projet' }, status: :unprocessable_entity
          return
        end

        if @project.owner == current_api_user
          render json: { error: 'Le créateur ne peut pas quitter son propre projet' }, status: :unprocessable_entity
          return
        end

        Project.transaction do
          @project.lock!
          team.destroy!
          @project.decrement!(:current_members_count)
        end

        render json: { message: 'Vous avez quitté le projet' }
      end

      private

      def set_project
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:title, :description, :status, :visibility, :max_members, :start_date, :end_date, :deadline)
      end

      def project_summary_json(project)
        {
          id: project.id,
          title: project.title,
          description: project.description,
          status: project.status,
          visibility: project.visibility,
          current_members_count: project.current_members_count,
          max_members: project.max_members,
          accepting_members: project.accepting_members?,
          owner: {
            id: project.owner.id,
            username: project.owner.username,
            name: project.owner.name
          },
          skills: project.skills.map { |s| { id: s.id, name: s.name, category: s.category } },
          created_at: project.created_at,
          updated_at: project.updated_at
        }
      end

      def project_detail_json(project)
        project_summary_json(project).merge(
          start_date: project.start_date,
          end_date: project.end_date,
          deadline: project.deadline,
          messages_count: project.messages_count,
          bookmarks_count: project.bookmarks_count,
          members: project.members.map { |u| {
            id: u.id,
            username: u.username,
            name: u.name,
            avatar_url: u.avatar_url,
            level: u.level
          }}
        )
      end
    end
  end
end
