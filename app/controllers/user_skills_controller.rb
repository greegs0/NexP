class UserSkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_skill, only: [:create]
  before_action :set_user_skill, only: [:destroy]

  def create
    @user_skill = current_user.user_skills.build(skill: @skill)

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
end
