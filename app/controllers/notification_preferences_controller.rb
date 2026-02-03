class NotificationPreferencesController < ApplicationController
  before_action :authenticate_user!

  def index
    @preferences = current_user.notification_preferences.index_by(&:notification_type)

    # Créer les préférences manquantes avec les valeurs par défaut
    NotificationPreference::NOTIFICATION_TYPES.each do |type|
      unless @preferences[type]
        @preferences[type] = current_user.notification_preferences.build(
          notification_type: type,
          enabled: true,
          email_enabled: false
        )
      end
    end
  end

  def update
    preferences_params = params.require(:preferences)

    NotificationPreference::NOTIFICATION_TYPES.each do |type|
      pref = current_user.notification_preferences.find_or_initialize_by(notification_type: type)

      # Récupérer les valeurs depuis les params
      enabled = preferences_params.dig(type, :enabled) == '1'
      email_enabled = preferences_params.dig(type, :email_enabled) == '1'

      pref.assign_attributes(
        enabled: enabled,
        email_enabled: email_enabled
      )

      pref.save!
    end

    redirect_to notification_preferences_path, notice: 'Vos préférences ont été mises à jour.'
  rescue => e
    Rails.logger.error "Error updating notification preferences: #{e.message}"
    redirect_to notification_preferences_path, alert: 'Une erreur est survenue lors de la mise à jour.'
  end
end
