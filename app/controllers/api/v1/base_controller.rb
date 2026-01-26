module Api
  module V1
    class BaseController < ActionController::API
      include ApiAuthenticable

      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
      rescue_from ActionController::ParameterMissing, with: :parameter_missing

      private

      def record_not_found(exception)
        render json: { error: 'Ressource non trouvée', details: exception.message }, status: :not_found
      end

      def record_invalid(exception)
        render json: { error: 'Validation échouée', details: exception.record.errors.full_messages }, status: :unprocessable_entity
      end

      def parameter_missing(exception)
        render json: { error: 'Paramètre manquant', details: exception.message }, status: :bad_request
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
