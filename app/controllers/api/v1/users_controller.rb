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
          users: UserSerializer.collection(@users),
          meta: pagination_meta(@users)
        }
      end

      # GET /api/v1/users/:id
      def show
        render json: { user: UserSerializer.new(@user).as_json(detail: true) }
      end

      # PATCH/PUT /api/v1/users/:id
      def update
        unless @user.id == current_api_user.id
          render json: { error: 'Non autorisé' }, status: :forbidden
          return
        end

        if @user.update(user_params)
          render json: { user: UserSerializer.new(@user).as_json(detail: true) }
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
          ExperienceService.award_with_notification(
            actor: current_api_user,
            action: :follow_given,
            target_user: @user,
            notifiable: @user
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
        render json: { user: UserSerializer.new(current_api_user).as_json(detail: true) }
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :bio, :zipcode, :portfolio_url, :github_url, :linkedin_url, :available, :avatar_url)
      end
    end
  end
end
