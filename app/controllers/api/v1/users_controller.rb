module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: [:show, :update, :follow, :unfollow]
      skip_before_action :authenticate_api_user!, only: [:index, :show]

      # GET /api/v1/users
      def index
        @users = User.includes(:skills).order(created_at: :desc)

        # Filtres
        @users = @users.where("username ILIKE ? OR name ILIKE ? OR bio ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
        @users = @users.with_skill(params[:skill_id]) if params[:skill_id].present?
        @users = @users.available if params[:available] == 'true'
        @users = @users.by_level(params[:min_level].to_i) if params[:min_level].present?

        @users = @users.distinct.page(params[:page]).per(params[:per_page] || 20)

        render json: {
          users: @users.map { |u| user_summary_json(u) },
          meta: pagination_meta(@users)
        }
      end

      # GET /api/v1/users/:id
      def show
        render json: {
          user: user_detail_json(@user)
        }
      end

      # PATCH/PUT /api/v1/users/:id
      def update
        unless @user.id == current_api_user.id
          render json: { error: 'Non autorisé' }, status: :forbidden
          return
        end

        if @user.update(user_params)
          render json: { user: user_detail_json(@user) }
        else
          render json: { error: 'Mise à jour échouée', details: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/users/:id/follow
      def follow
        if current_api_user.following?(@user)
          render json: { error: 'Vous suivez déjà cet utilisateur' }, status: :unprocessable_entity
        else
          current_api_user.follow(@user)
          current_api_user.add_experience(5)

          Notification.create(
            user: @user,
            actor: current_api_user,
            notifiable: @user,
            action: 'follow'
          )

          render json: { message: 'Utilisateur suivi avec succès' }
        end
      end

      # DELETE /api/v1/users/:id/unfollow
      def unfollow
        if current_api_user.following?(@user)
          current_api_user.unfollow(@user)
          render json: { message: 'Utilisateur non suivi avec succès' }
        else
          render json: { error: 'Vous ne suivez pas cet utilisateur' }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/users/me
      def me
        render json: { user: user_detail_json(current_api_user) }
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :bio, :zipcode, :portfolio_url, :github_url, :linkedin_url, :available, :avatar_url)
      end

      def user_summary_json(user)
        {
          id: user.id,
          username: user.username,
          name: user.name,
          bio: user.bio,
          level: user.level,
          available: user.available,
          avatar_url: user.avatar_url,
          skills_count: user.skills.count,
          followers_count: user.followers_count,
          following_count: user.following_count
        }
      end

      def user_detail_json(user)
        user_summary_json(user).merge(
          email: user.email,
          zipcode: user.zipcode,
          portfolio_url: user.portfolio_url,
          github_url: user.github_url,
          linkedin_url: user.linkedin_url,
          experience_points: user.experience_points,
          posts_count: user.posts_count,
          owned_projects_count: user.owned_projects_count,
          bookmarks_count: user.bookmarks_count,
          skills: user.skills.map { |s| { id: s.id, name: s.name, category: s.category } },
          badges: user.badges.map { |b| { id: b.id, name: b.name, description: b.description } }
        )
      end
    end
  end
end
