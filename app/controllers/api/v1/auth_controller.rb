module Api
  module V1
    class AuthController < ActionController::API
      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: user_json(user),
            expires_at: 24.hours.from_now
          }, status: :ok
        else
          render json: { error: 'Email ou mot de passe invalide' }, status: :unauthorized
        end
      end

      # POST /api/v1/auth/signup
      def signup
        user = User.new(signup_params)

        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: user_json(user),
            expires_at: 24.hours.from_now
          }, status: :created
        else
          render json: { error: 'Inscription échouée', details: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def signup_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username, :name)
      end

      def user_json(user)
        {
          id: user.id,
          email: user.email,
          username: user.username,
          name: user.name,
          bio: user.bio,
          level: user.level,
          experience_points: user.experience_points,
          available: user.available
        }
      end
    end
  end
end
