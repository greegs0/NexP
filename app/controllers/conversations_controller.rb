class ConversationsController < ApplicationController
  include Broadcastable
  include PlanLimits

  before_action :authenticate_user!
  before_action :set_recipient, only: [:show, :create]
  before_action :check_message_limit!, only: [:create]

  def index
    # Récupérer tous les utilisateurs avec qui on a eu des conversations
    sent_to = current_user.sent_messages.direct_messages.pluck(:recipient_id).uniq
    received_from = current_user.received_messages.direct_messages.pluck(:sender_id).uniq
    user_ids = (sent_to + received_from).uniq

    @conversations = User.where(id: user_ids)
                         .order(created_at: :desc)
                         .page(params[:page]).per(20)
  end

  def show
    @messages = Message.conversation_between(current_user, @recipient)
                       .includes(:sender)

    # Marquer les messages reçus comme lus
    @messages.where(recipient: current_user, read_at: nil).update_all(read_at: Time.current)
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    @message.recipient = @recipient

    if @message.save
      # Incrémenter le compteur de messages pour le plan
      current_user.increment_message_count!

      # Créer et broadcaster une notification
      notification = Notification.create(
        user: @recipient,
        actor: current_user,
        notifiable: @message,
        action: 'message'
      )
      broadcast_notification(notification)

      # Broadcaster le message en temps réel
      broadcast_message(@message, @recipient.id)

      # Attribution de XP
      current_user.add_experience(3)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to conversation_path(@recipient), notice: 'Message envoyé.' }
      end
    else
      @messages = Message.conversation_between(current_user, @recipient).includes(:sender)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace('message_form_container', partial: 'form', locals: { recipient: @recipient, message: @message }) }
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_recipient
    @recipient = User.find(params[:id] || params[:conversation_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to conversations_path, alert: "Cet utilisateur n'existe pas."
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
