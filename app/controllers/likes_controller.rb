class LikesController < ApplicationController
  include Broadcastable

  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = @post.likes.find_or_initialize_by(user: current_user)
    if @like.new_record?
      @like.save
      # Attribution de XP pour le like
      current_user.add_experience(2)
      # Attribution de XP pour l'auteur du post
      @post.user.add_experience(5) unless @post.user == current_user

      # Créer et broadcaster une notification
      unless @post.user == current_user
        notification = Notification.create(
          user: @post.user,
          actor: current_user,
          notifiable: @post,
          action: 'like'
        )
        broadcast_notification(notification)
      end
    else
      # Unlike - supprimer le like existant
      @like.destroy
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: posts_path, notice: @like.persisted? ? 'Post liké!' : 'Like retiré.') }
      format.turbo_stream
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "Ce post n'existe pas."
  end
end
