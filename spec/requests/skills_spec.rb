# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Skills", type: :request do
  let(:user) { create(:user) }
  let!(:skill) { create(:skill, name: 'Ruby', category: 'Backend') }
  let!(:skill2) { create(:skill, name: 'React', category: 'Frontend') }

  describe "GET /skills" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get skills_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "returns http success" do
        get skills_path
        expect(response).to have_http_status(:success)
      end

      it "displays available skills" do
        get skills_path
        expect(response.body).to include('Ruby')
        expect(response.body).to include('React')
      end

      it "filters by category" do
        get skills_path, params: { category: 'Backend' }
        expect(response.body).to include('Ruby')
      end

      it "filters by search term" do
        get skills_path, params: { search: 'Ruby' }
        expect(response.body).to include('Ruby')
      end
    end
  end

  describe "GET /skills/:id" do
    before { sign_in user }

    it "returns http success" do
      get skill_path(skill)
      expect(response).to have_http_status(:success)
    end

    it "displays skill details" do
      get skill_path(skill)
      expect(response.body).to include('Ruby')
      expect(response.body).to include('Backend')
    end

    it "shows users with this skill" do
      create(:user_skill, user: user, skill: skill)

      get skill_path(skill)
      expect(response.body).to include(user.display_name)
    end
  end
end
