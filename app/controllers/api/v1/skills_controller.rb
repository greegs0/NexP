module Api
  module V1
    class SkillsController < BaseController
      skip_before_action :authenticate_api_user!

      # GET /api/v1/skills
      def index
        @skills = Skill.all_cached

        # Filtres
        if params[:category].present?
          @skills = @skills.select { |s| s.category == params[:category] }
        end

        if params[:search].present?
          @skills = @skills.select { |s| s.name.downcase.include?(params[:search].downcase) }
        end

        render json: {
          skills: @skills.map { |s| skill_json(s) },
          categories: Skill::CATEGORIES
        }
      end

      # GET /api/v1/skills/:id
      def show
        @skill = Skill.find(params[:id])
        render json: {
          skill: skill_json(@skill),
          users_count: @skill.users.count,
          projects_count: @skill.projects.count
        }
      end

      # GET /api/v1/skills/categories
      def categories
        skills_by_category = Skill.categories_with_skills

        render json: {
          categories: skills_by_category.map do |category, skills|
            {
              name: category,
              skills: skills.map { |s| skill_json(s) }
            }
          end
        }
      end

      private

      def skill_json(skill)
        {
          id: skill.id,
          name: skill.name,
          category: skill.category
        }
      end
    end
  end
end
