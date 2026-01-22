# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "UserSkills", type: :request do
  let(:user) { create(:user) }
  let(:skill) { create(:skill, name: 'Ruby', category: 'Backend') }

  describe "POST /user_skills" do
    context "when not authenticated" do
      it "redirects to sign in" do
        post user_skills_path, params: { skill_id: skill.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "adds a skill to the user" do
        expect {
          post user_skills_path, params: { skill_id: skill.id }
        }.to change(UserSkill, :count).by(1)

        expect(user.skills).to include(skill)
      end

      it "does not add the same skill twice" do
        create(:user_skill, user: user, skill: skill)

        expect {
          post user_skills_path, params: { skill_id: skill.id }
        }.not_to change(UserSkill, :count)
      end

      it "redirects to skills page" do
        post user_skills_path, params: { skill_id: skill.id }
        expect(response).to redirect_to(skills_path)
      end
    end
  end

  describe "DELETE /user_skills/:id" do
    context "when not authenticated" do
      it "redirects to sign in" do
        user_skill = create(:user_skill, user: user, skill: skill)
        delete user_skill_path(user_skill)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "removes a skill from the user" do
        user_skill = create(:user_skill, user: user, skill: skill)

        expect {
          delete user_skill_path(user_skill)
        }.to change(UserSkill, :count).by(-1)

        expect(user.skills).not_to include(skill)
      end

      it "does not allow removing another user's skill" do
        other_user = create(:user)
        other_user_skill = create(:user_skill, user: other_user, skill: skill)

        expect {
          delete user_skill_path(other_user_skill)
        }.not_to change(UserSkill, :count)
      end

      it "redirects to skills page" do
        user_skill = create(:user_skill, user: user, skill: skill)
        delete user_skill_path(user_skill)
        expect(response).to redirect_to(skills_path)
      end
    end
  end
end
