class MessagesController < ApplicationController
  include PlanLimits

  before_action :authenticate_user!
  before_action :set_project
  before_action :authorize_member!
  before_action :check_message_limit!, only: [:create]

  def index
    @messages = @project.messages
                        .includes(:sender)
                        .order(created_at: :asc)

    # Marquer les messages comme lus
    @messages.where.not(sender: current_user)
             .where(read_at: nil)
             .update_all(read_at: Time.current)

    @message = @project.messages.build
  end

  def create
    @message = @project.messages.build(message_params)
    @message.sender = current_user

    if @message.save
      # Incrémenter le compteur de messages pour le plan
      current_user.increment_message_count!

      respond_to do |format|
        format.html { redirect_to project_messages_path(@project), notice: 'Message envoyé.' }
        format.turbo_stream
      end
    else
      @messages = @project.messages.includes(:sender).order(created_at: :asc)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: "Ce projet n'existe pas."
  end

  def authorize_member!
    unless @project.members.include?(current_user) || @project.owner == current_user
      redirect_to @project, alert: "Vous devez être membre du projet pour accéder aux messages."
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
