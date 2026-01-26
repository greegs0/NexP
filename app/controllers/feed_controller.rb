class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    # Récupérer les posts des utilisateurs suivis + ses propres posts
    following_ids = current_user.following.pluck(:id)
    user_ids = following_ids + [current_user.id]

    @posts = Post.where(user_id: user_ids)
                 .includes(:user, :likes, comments: :user, image_attachment: :blob)
                 .order(created_at: :desc)
                 .page(params[:page]).per(20)

    # Récupérer les projets récents des utilisateurs suivis
    @recent_projects = Project.where(owner_id: user_ids)
                              .where(visibility: 'public')
                              .includes(:owner, :skills)
                              .order(created_at: :desc)
                              .limit(5)

    # Suggestions d'utilisateurs à suivre (utilisateurs avec des skills similaires)
    user_skill_ids = current_user.skills.pluck(:id)
    @suggested_users = User.joins(:user_skills)
                           .where(user_skills: { skill_id: user_skill_ids })
                           .where.not(id: [current_user.id] + following_ids)
                           .includes(:skills)
                           .distinct
                           .limit(5)
  end
end
