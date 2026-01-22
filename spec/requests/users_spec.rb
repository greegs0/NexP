# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /users/:id" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get user_path(other_user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "returns http success" do
        get user_path(other_user)
        expect(response).to have_http_status(:success)
      end

      it "displays user information" do
        get user_path(other_user)
        expect(response.body).to include(other_user.username)
      end

      it "displays user skills" do
        skill = create(:skill, name: 'Ruby')
        create(:user_skill, user: other_user, skill: skill)

        get user_path(other_user)
        expect(response.body).to include('Ruby')
      end
    end
  end

  describe "GET /users/:id/portfolio" do
    before { sign_in user }

    it "returns http success" do
      get portfolio_user_path(other_user)
      expect(response).to have_http_status(:success)
    end

    it "displays portfolio page" do
      get portfolio_user_path(other_user)
      expect(response.body).to include('Portfolio')
      expect(response.body).to include(other_user.display_name)
    end

    it "shows user projects" do
      project = create(:project, owner: other_user, title: 'My Portfolio Project')

      get portfolio_user_path(other_user)
      expect(response.body).to include(project.title)
    end
  end

  describe "PATCH /users/:id/toggle_availability" do
    before { sign_in user }

    it "toggles availability for own profile" do
      user.update!(available: false)

      patch toggle_availability_user_path(user), params: { available: true }, as: :json

      expect(response).to have_http_status(:success)
      expect(user.reload.available).to be true
    end

    it "returns updated availability in JSON" do
      patch toggle_availability_user_path(user), params: { available: true }, as: :json

      json_response = JSON.parse(response.body)
      expect(json_response['available']).to eq(true)
    end

    it "does not allow toggling another user's availability" do
      other_user.update!(available: false)

      patch toggle_availability_user_path(other_user), params: { available: true }, as: :json

      expect(response).to have_http_status(:forbidden)
      expect(other_user.reload.available).to be false
    end
  end
end
