class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :portfolio, :toggle_availability, :follow, :unfollow]

  def index
    @users = User.order(followers_count: :desc, created_at: :desc)

    # Filtres de recherche
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @users = @users.where("username ILIKE ? OR name ILIKE ? OR bio ILIKE ?", search_term, search_term, search_term)
    end

    if params[:skill_id].present?
      @users = @users.joins(:user_skills).where(user_skills: { skill_id: params[:skill_id] })
    end

    if params[:available].present?
      @users = @users.where(available: params[:available] == 'true')
    end

    @users = @users.distinct.page(params[:page]).per(20)
  end

  def show
    @user_skills = @user.skills.order(:category, :name)
    @owned_projects = @user.owned_projects.includes(:skills, :owner).order(created_at: :desc).limit(6)
    @participated_projects = @user.projects.where.not(owner: @user).includes(:owner, :skills).order(created_at: :desc).limit(6)
    @badges = @user.badges.joins(:user_badges).where(user_badges: { user_id: @user.id }).order('user_badges.earned_at DESC')

    @total_projects = @user.owned_projects_count + @participated_projects.size
    @is_current_user = @user == current_user
  end

  def portfolio
    @user_skills = @user.skills.order(:category, :name)
    # Utiliser une requête SQL au lieu de combiner en Ruby
    @all_projects = Project.where(id: @user.owned_projects.pluck(:id) + @user.projects.pluck(:id))
                           .includes(:owner, :skills, :members)
                           .order(created_at: :desc)
  end

  def toggle_availability
    if current_user == @user
      @user.update(available: params[:available])
      render json: { available: @user.available }
    else
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  def follow
    if current_user.following?(@user)
      redirect_to @user, alert: 'Vous suivez déjà cet utilisateur.'
    else
      current_user.follow(@user)
      # Créer une notification
      Notification.create(
        user: @user,
        actor: current_user,
        notifiable: @user,
        action: 'follow'
      )
      # Attribution de XP
      current_user.add_experience(5)
      redirect_to @user, notice: 'Vous suivez maintenant cet utilisateur.'
    end
  end

  def unfollow
    if current_user.following?(@user)
      current_user.unfollow(@user)
      redirect_to @user, notice: 'Vous ne suivez plus cet utilisateur.'
    else
      redirect_to @user, alert: 'Vous ne suivez pas cet utilisateur.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Cet utilisateur n'existe pas."
  end
end
