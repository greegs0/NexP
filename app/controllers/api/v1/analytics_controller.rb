module Api
  module V1
    class AnalyticsController < BaseController
      skip_before_action :authenticate_api_user!, only: [:platform]

      # GET /api/v1/analytics/platform
      # Statistiques globales de la plateforme
      def platform
        stats = AnalyticsService.platform_stats

        render json: {
          stats: stats,
          generated_at: Time.current
        }
      end

      # GET /api/v1/analytics/me
      # Statistiques personnelles de l'utilisateur connecté
      def me
        stats = AnalyticsService.user_stats(current_api_user)

        render json: {
          stats: stats,
          generated_at: Time.current
        }
      end

      # GET /api/v1/analytics/user/:id
      # Statistiques publiques d'un utilisateur
      def user
        @user = User.find(params[:id])
        stats = AnalyticsService.user_stats(@user)

        # Filtrer les données sensibles pour les autres utilisateurs
        if @user.id != current_api_user.id
          stats = filter_sensitive_data(stats)
        end

        render json: {
          stats: stats,
          generated_at: Time.current
        }
      end

      # GET /api/v1/analytics/project/:id
      # Statistiques d'un projet
      def project
        @project = Project.find(params[:id])

        # Vérifier les permissions
        unless @project.visibility == 'public' || @project.owner == current_api_user || @project.members.include?(current_api_user)
          render json: { error: 'Non autorisé' }, status: :forbidden
          return
        end

        stats = AnalyticsService.project_stats(@project)

        render json: {
          stats: stats,
          generated_at: Time.current
        }
      end

      # GET /api/v1/analytics/trending
      # Données sur les tendances
      def trending
        data = AnalyticsService.trending_data

        render json: {
          trending: data,
          generated_at: Time.current
        }
      end

      private

      def filter_sensitive_data(stats)
        # Retirer les données sensibles pour les utilisateurs non connectés
        stats.except(:timeline)
      end
    end
  end
end
