# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  let(:user) { create(:user) }

  describe "GET /dashboard" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get dashboard_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "returns http success" do
        get dashboard_path
        expect(response).to have_http_status(:success)
      end

      it "displays user information" do
        get dashboard_path
        expect(response.body).to include(user.display_name)
      end

      it "shows user skills" do
        skill = create(:skill, name: 'Python')
        create(:user_skill, user: user, skill: skill)

        get dashboard_path
        expect(response.body).to include('Python')
      end

      it "shows recent projects" do
        project = create(:project, owner: user, title: 'Dashboard Test Project')

        get dashboard_path
        expect(response.body).to include('Dashboard Test Project')
      end

      it "shows projects user has joined" do
        other_user = create(:user)
        project = create(:project, owner: other_user, title: 'Joined Project')
        create(:team, user: user, project: project)

        get dashboard_path
        expect(response.body).to include('Joined Project')
      end
    end
  end
end
