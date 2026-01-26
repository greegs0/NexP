module Api
  module V1
    class MatchingController < BaseController
      # GET /api/v1/matching/projects
      # Trouve les meilleurs projets pour l'utilisateur courant
      def projects
        limit = params[:limit]&.to_i || 10
        @projects = MatchingService.find_projects_for_user(current_api_user, limit: limit)

        render json: {
          projects: @projects.map { |p| project_match_json(p, current_api_user) }
        }
      end

      # GET /api/v1/matching/users?project_id=:id
      # Trouve les meilleurs utilisateurs pour un projet donné
      def users
        @project = Project.find(params[:project_id])

        unless @project.owner == current_api_user
          render json: { error: 'Non autorisé' }, status: :forbidden
          return
        end

        limit = params[:limit]&.to_i || 10
        @users = MatchingService.find_users_for_project(@project, limit: limit)

        render json: {
          users: @users.map { |u| user_match_json(u, @project) }
        }
      end

      # GET /api/v1/matching/similar_users
      # Trouve des utilisateurs similaires à l'utilisateur courant
      def similar_users
        limit = params[:limit]&.to_i || 10
        @users = MatchingService.find_similar_users(current_api_user, limit: limit)

        render json: {
          users: @users.map { |u| user_summary_json(u) }
        }
      end

      private

      def project_match_json(project, user)
        common_skills = (user.skills.pluck(:id) & project.skills.pluck(:id))
        match_percentage = (common_skills.size.to_f / project.skills.size * 100).round if project.skills.any?

        {
          id: project.id,
          title: project.title,
          description: project.description,
          status: project.status,
          current_members_count: project.current_members_count,
          max_members: project.max_members,
          match_percentage: match_percentage || 0,
          common_skills_count: common_skills.size,
          owner: {
            id: project.owner.id,
            username: project.owner.username,
            name: project.owner.name
          },
          skills: project.skills.map { |s| { id: s.id, name: s.name, category: s.category } },
          common_skills: Skill.where(id: common_skills).map { |s| { id: s.id, name: s.name, category: s.category } }
        }
      end

      def user_match_json(user, project)
        common_skills = (user.skills.pluck(:id) & project.skills.pluck(:id))
        match_percentage = (common_skills.size.to_f / project.skills.size * 100).round if project.skills.any?

        {
          id: user.id,
          username: user.username,
          name: user.name,
          bio: user.bio,
          level: user.level,
          available: user.available,
          match_percentage: match_percentage || 0,
          common_skills_count: common_skills.size,
          skills: user.skills.map { |s| { id: s.id, name: s.name, category: s.category } },
          common_skills: Skill.where(id: common_skills).map { |s| { id: s.id, name: s.name, category: s.category } }
        }
      end

      def user_summary_json(user)
        {
          id: user.id,
          username: user.username,
          name: user.name,
          bio: user.bio,
          level: user.level,
          available: user.available,
          skills_count: user.skills.count,
          common_skills_count: user.respond_to?(:common_skills_count) ? user.common_skills_count : 0
        }
      end
    end
  end
end
