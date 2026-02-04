# frozen_string_literal: true

module PlanLimits
  extend ActiveSupport::Concern

  private

  def check_project_limit!
    return if current_user.can_create_project?

    respond_to do |format|
      format.html { redirect_to projects_path, alert: "Limite atteinte : #{User::FREE_PROJECT_LIMIT} projet actif maximum en plan gratuit." }
      format.json { render json: { error: "Plan limit reached", message: "Maximum #{User::FREE_PROJECT_LIMIT} active project on free plan" }, status: :forbidden }
      format.turbo_stream { redirect_to projects_path, alert: "Limite atteinte : #{User::FREE_PROJECT_LIMIT} projet actif maximum en plan gratuit." }
    end
  end

  def check_message_limit!
    return if current_user.can_send_message?

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, alert: "Limite atteinte : #{User::FREE_MESSAGE_LIMIT} messages/mois en plan gratuit." }
      format.json { render json: { error: "Message limit reached", message: "Maximum #{User::FREE_MESSAGE_LIMIT} messages per month on free plan" }, status: :forbidden }
      format.turbo_stream { redirect_back fallback_location: root_path, alert: "Limite atteinte : #{User::FREE_MESSAGE_LIMIT} messages/mois en plan gratuit." }
    end
  end
end
