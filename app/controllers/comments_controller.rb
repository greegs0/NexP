class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # Attribution de XP pour le commentaire
      current_user.add_experience(5)
      # Attribution de XP pour l'auteur du post
      @post.user.add_experience(3) unless @post.user == current_user
      redirect_to @post, notice: 'Commentaire ajouté avec succès.'
    else
      redirect_to @post, alert: 'Erreur lors de l\'ajout du commentaire.'
    end
  end

  def destroy
    if @comment.user == current_user || @post.user == current_user
      @comment.destroy
      redirect_to @post, notice: 'Commentaire supprimé avec succès.'
    else
      redirect_to @post, alert: "Vous n'êtes pas autorisé à supprimer ce commentaire."
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "Ce post n'existe pas."
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to @post, alert: "Ce commentaire n'existe pas."
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id, :image)
  end
end
