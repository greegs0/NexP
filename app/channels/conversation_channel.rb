class ConversationChannel < ApplicationCable::Channel
  def subscribed
    # Stream pour les conversations de l'utilisateur
    stream_from "conversation_#{current_user.id}_#{params[:recipient_id]}"
    stream_from "conversation_#{params[:recipient_id]}_#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
