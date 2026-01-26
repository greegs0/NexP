module Api
  module V1
    class PostsController < BaseController
      before_action :set_post, only: [:show, :update, :destroy, :like, :unlike]
      skip_before_action :authenticate_api_user!, only: [:index, :show]

      # GET /api/v1/posts
      def index
        @posts = Post.includes(:user, :likes, comments: :user, image_attachment: :blob).order(created_at: :desc)
        @posts = @posts.page(params[:page]).per(params[:per_page] || 20)

        render json: {
          posts: @posts.map { |p| post_json(p, current_api_user) },
          meta: pagination_meta(@posts)
        }
      end

      # GET /api/v1/posts/feed
      def feed
        following_ids = current_api_user.following.pluck(:id)
        user_ids = following_ids + [current_api_user.id]

        @posts = Post.where(user_id: user_ids)
                     .includes(:user, :likes, comments: :user, image_attachment: :blob)
                     .order(created_at: :desc)
                     .page(params[:page]).per(params[:per_page] || 20)

        render json: {
          posts: @posts.map { |p| post_json(p, current_api_user) },
          meta: pagination_meta(@posts)
        }
      end

      # GET /api/v1/posts/:id
      def show
        render json: {
          post: post_json(@post, current_api_user)
        }
      end

      # POST /api/v1/posts
      def create
        @post = current_api_user.posts.build(post_params)

        if @post.save
          current_api_user.add_experience(10)
          render json: { post: post_json(@post, current_api_user) }, status: :created
        else
          render json: { error: 'Création échouée', details: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/posts/:id
      def update
        unless @post.user == current_api_user
          render json: { error: 'Non autorisé' }, status: :forbidden
          return
        end

        if @post.update(post_params)
          render json: { post: post_json(@post, current_api_user) }
        else
          render json: { error: 'Mise à jour échouée', details: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/posts/:id
      def destroy
        unless @post.user == current_api_user
          render json: { error: 'Non autorisé' }, status: :forbidden
          return
        end

        @post.destroy
        render json: { message: 'Post supprimé avec succès' }
      end

      # POST /api/v1/posts/:id/like
      def like
        like = @post.likes.find_by(user: current_api_user)

        if like
          render json: { error: 'Vous avez déjà liké ce post' }, status: :unprocessable_entity
        else
          @post.likes.create!(user: current_api_user)
          current_api_user.add_experience(2)
          @post.user.add_experience(5)

          Notification.create(
            user: @post.user,
            actor: current_api_user,
            notifiable: @post,
            action: 'like'
          )

          render json: { message: 'Post liké avec succès', likes_count: @post.likes_count }
        end
      end

      # DELETE /api/v1/posts/:id/unlike
      def unlike
        like = @post.likes.find_by(user: current_api_user)

        if like
          like.destroy
          render json: { message: 'Like retiré avec succès', likes_count: @post.likes_count }
        else
          render json: { error: 'Vous n\'avez pas liké ce post' }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/posts/:id/comments
      def comments
        @post = Post.find(params[:id])
        @comments = @post.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(params[:per_page] || 50)

        render json: {
          comments: @comments.map { |c| comment_json(c) },
          meta: pagination_meta(@comments)
        }
      end

      # POST /api/v1/posts/:id/comments
      def create_comment
        @post = Post.find(params[:id])
        @comment = @post.comments.build(content: params[:content], user: current_api_user)

        if @comment.save
          current_api_user.add_experience(5)
          @post.user.add_experience(3)

          Notification.create(
            user: @post.user,
            actor: current_api_user,
            notifiable: @comment,
            action: 'comment'
          )

          render json: { comment: comment_json(@comment) }, status: :created
        else
          render json: { error: 'Création échouée', details: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_post
        @post = Post.includes(:user, :likes, comments: :user, image_attachment: :blob).find(params[:id])
      end

      def post_params
        params.require(:post).permit(:content, :image)
      end

      def post_json(post, current_user = nil)
        {
          id: post.id,
          content: post.content,
          likes_count: post.likes_count,
          comments_count: post.comments_count,
          created_at: post.created_at,
          updated_at: post.updated_at,
          user: {
            id: post.user.id,
            username: post.user.username,
            name: post.user.name,
            avatar_url: post.user.avatar_url,
            level: post.user.level
          },
          image_url: post.image.attached? ? Rails.application.routes.url_helpers.url_for(post.image) : nil,
          liked_by_current_user: current_user ? post.likes.exists?(user: current_user) : false,
          recent_comments: post.comments.includes(:user).order(created_at: :desc).limit(3).map { |c| comment_json(c) }
        }
      end

      def comment_json(comment)
        {
          id: comment.id,
          content: comment.content,
          created_at: comment.created_at,
          user: {
            id: comment.user.id,
            username: comment.user.username,
            name: comment.user.name,
            avatar_url: comment.user.avatar_url
          }
        }
      end
    end
  end
end
