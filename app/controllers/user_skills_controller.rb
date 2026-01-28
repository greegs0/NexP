class UserSkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_skill, only: [:create]
  before_action :set_user_skill, only: [:destroy, :update]

  def create
    # Assigner la position à la fin
    max_position = current_user.user_skills.maximum(:position) || -1
    @user_skill = current_user.user_skills.build(
      skill: @skill,
      position: max_position + 1,
      proficiency_level: params[:proficiency_level] || :beginner
    )

    respond_to do |format|
      if @user_skill.save
        format.html { redirect_to skills_path, notice: "#{@skill.name} ajoutée à vos compétences." }
        format.turbo_stream { flash.now[:notice] = "#{@skill.name} ajoutée." }
      else
        format.html { redirect_to skills_path, alert: "Erreur : #{@user_skill.errors.full_messages.join(', ')}" }
      end
    end
  rescue ActiveRecord::RecordNotUnique
    redirect_to skills_path, alert: "Vous possédez déjà cette compétence."
  end

  def update
    respond_to do |format|
      if @user_skill.update(user_skill_params)
        format.html { redirect_to skills_path, notice: "Niveau mis à jour." }
        format.json { render json: { success: true, proficiency: @user_skill.proficiency_label } }
        format.turbo_stream
      else
        format.html { redirect_to skills_path, alert: "Impossible de mettre à jour." }
        format.json { render json: { success: false }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    skill_name = @user_skill.skill.name

    respond_to do |format|
      if @user_skill.destroy
        format.html { redirect_to skills_path, notice: "#{skill_name} retirée de vos compétences." }
        format.turbo_stream { flash.now[:notice] = "#{skill_name} retirée." }
      else
        format.html { redirect_to skills_path, alert: "Impossible de retirer cette compétence." }
      end
    end
  end

  # Réorganiser l'ordre des compétences
  def reorder
    skill_ids = params[:skill_ids] || []

    ActiveRecord::Base.transaction do
      skill_ids.each_with_index do |id, index|
        current_user.user_skills.find_by(id: id)&.update_column(:position, index)
      end
    end

    respond_to do |format|
      format.json { render json: { success: true } }
      format.html { redirect_to skills_path, notice: "Ordre mis à jour." }
    end
  end

  private

  def set_skill
    @skill = Skill.find(params[:skill_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to skills_path, alert: "Cette compétence n'existe pas."
  end

  def set_user_skill
    @user_skill = current_user.user_skills.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to skills_path, alert: "Vous ne possédez pas cette compétence."
  end

  def user_skill_params
    params.require(:user_skill).permit(:proficiency_level)
  end
end
