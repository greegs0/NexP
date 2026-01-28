class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    # Récupérer les posts des utilisateurs suivis + ses propres posts
    following_ids = current_user.following.pluck(:id)
    user_ids = following_ids + [current_user.id]

    # Base query pour les posts
    @posts = Post.where(user_id: user_ids)
                 .includes(:user, :likes, comments: :user, image_attachment: :blob)

    # Appliquer les filtres
    @posts = apply_filters(@posts, user_ids)

    @posts = @posts.order(created_at: :desc)
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

    # Compétences pour le filtre
    @filter_skills = Skill.joins(:users)
                          .where(users: { id: user_ids })
                          .distinct
                          .order(:name)
                          .limit(20)

    # Filtre actif
    @active_filter = params[:filter]
    @active_skill = params[:skill_id]
  end

  private

  def apply_filters(posts, user_ids)
    case params[:filter]
    when 'images'
      # Posts avec images
      posts.joins(:image_attachment)
    when 'popular'
      # Posts populaires (triés par likes)
      posts.left_joins(:likes)
           .group('posts.id')
           .order('COUNT(likes.id) DESC')
    when 'commented'
      # Posts avec commentaires
      posts.joins(:comments).distinct
    when 'mine'
      # Mes posts uniquement
      posts.where(user_id: current_user.id)
    when 'skill'
      # Posts de personnes avec une compétence spécifique
      if params[:skill_id].present?
        skill_user_ids = UserSkill.where(skill_id: params[:skill_id])
                                  .pluck(:user_id) & user_ids
        posts.where(user_id: skill_user_ids)
      else
        posts
      end
    else
      posts
    end
  end
end
