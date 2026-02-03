class PostsController < ApplicationController
  include Authorizable

  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action -> { authorize_owner!(@post, :user) }, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user, :likes, comments: :user, image_attachment: :blob)
                 .order(created_at: :desc)
                 .page(params[:page]).per(20)
  end

  def show
    @comments = @post.comments.top_level
                     .includes(:user, :image_attachment, replies: [:user, :image_attachment])
                     .order(created_at: :desc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      ExperienceService.award(user: current_user, action: :post_created)
      redirect_to posts_path, notice: 'Post créé avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post mis à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post supprimé avec succès.'
  end

  private

  def set_post
    @post = Post.includes(:user, :likes, comments: :user, image_attachment: :blob).find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
