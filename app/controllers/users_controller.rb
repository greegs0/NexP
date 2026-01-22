class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :portfolio, :toggle_availability]

  def show
    @user_skills = @user.skills.includes(:user_skills).order(:category, :name)
    @owned_projects = @user.owned_projects.includes(:skills).order(created_at: :desc).limit(6)
    @participated_projects = @user.projects.where.not(owner: @user).includes(:owner, :skills).order(created_at: :desc).limit(6)
    @badges = @user.badges.includes(:user_badges).order('user_badges.earned_at DESC')

    @total_projects = @owned_projects.size + @participated_projects.size
    @is_current_user = @user == current_user
  end

  def portfolio
    @user_skills = @user.skills.order(:category, :name)
    @all_projects = (@user.owned_projects + @user.projects).uniq.sort_by(&:created_at).reverse
  end

  def toggle_availability
    if current_user == @user
      @user.update(available: params[:available])
      render json: { available: @user.available }
    else
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Cet utilisateur n'existe pas."
  end
end
