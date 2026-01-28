class SkillsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Skills de l'utilisateur
    @user_skills = current_user.user_skills.includes(:skill)

    # IDs des skills de l'utilisateur
    user_skill_ids = current_user.skills.pluck(:id)

    # Suggestions toujours chargées
    @suggestions = Skill.suggestions_for(current_user)

    # Résultats de recherche uniquement si query présente
    if params[:search].present?
      search_results = Skill.smart_search(params[:search], user: current_user, limit: 30)
      @available_skills = search_results.reject { |s| user_skill_ids.include?(s.id) }
      @skills_by_category = @available_skills.group_by(&:category)
    else
      @skills_by_category = {}
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "search_results",
          partial: "skills/search_results_only",
          locals: { skills_by_category: @skills_by_category }
        )
      end
      format.json do
        render json: {
          skills: @skills_by_category.flat_map { |_, skills| skills.map { |s| skill_json(s) } },
          suggestions: format_suggestions(@suggestions)
        }
      end
    end
  end

  def show
    @skill = Skill.find(params[:id])
    @users = @skill.users.includes(:user_skills)
    @projects = @skill.projects.includes(:owner, :skills)
  rescue ActiveRecord::RecordNotFound
    redirect_to skills_path, alert: "Cette competence n'existe pas."
  end

  # Endpoint autocomplete pour la recherche en temps reel
  def autocomplete
    query = params[:q].to_s.strip

    return render json: [] if query.length < 1

    results = Skill.smart_search(query, user: current_user, limit: 10)
                   .reject { |s| current_user.skills.include?(s) }

    render json: results.map { |skill|
      {
        id: skill.id,
        name: skill.name,
        category: skill.category,
        users_count: skill.users_count
      }
    }
  end

  private

  def skill_json(skill)
    {
      id: skill.id,
      name: skill.name,
      category: skill.category,
      users_count: skill.users_count
    }
  end

  def format_suggestions(suggestions)
    {
      based_on_skills: suggestions[:based_on_skills].map { |s| skill_json(s[:skill]).merge(reason: s[:reason]) },
      popular_in_category: suggestions[:popular_in_category].map { |s| skill_json(s[:skill]).merge(reason: s[:reason]) },
      complete_your_stack: suggestions[:complete_your_stack].map { |s| skill_json(s[:skill]).merge(reason: s[:reason]) },
      trending_now: suggestions[:trending_now].map { |s| skill_json(s[:skill]).merge(reason: s[:reason]) }
    }
  end
end
