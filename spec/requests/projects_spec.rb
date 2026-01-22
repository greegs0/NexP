# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:project) { create(:project, owner: user) }
  let(:public_project) { create(:project, owner: other_user, visibility: 'public') }

  describe "GET /projects" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get projects_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "returns http success" do
        get projects_path
        expect(response).to have_http_status(:success)
      end

      it "shows only public projects" do
        public_project
        private_project = create(:project, owner: other_user, visibility: 'private')

        get projects_path

        expect(response.body).to include(public_project.title)
        expect(response.body).not_to include(private_project.title)
      end

      it "filters by status" do
        open_project = create(:project, owner: other_user, visibility: 'public', status: 'open')
        completed_project = create(:project, owner: other_user, visibility: 'public', status: 'completed')

        get projects_path, params: { status: 'open' }

        expect(response.body).to include(open_project.title)
        expect(response.body).not_to include(completed_project.title)
      end

      it "filters by search term" do
        rails_project = create(:project, owner: other_user, visibility: 'public', title: 'Rails App')
        react_project = create(:project, owner: other_user, visibility: 'public', title: 'React App')

        get projects_path, params: { search: 'Rails' }

        expect(response.body).to include(rails_project.title)
        expect(response.body).not_to include(react_project.title)
      end
    end
  end

  describe "GET /projects/:id" do
    before { sign_in user }

    it "returns http success for existing project" do
      get project_path(public_project)
      expect(response).to have_http_status(:success)
    end

    it "redirects for non-existing project" do
      get project_path(id: 999999)
      expect(response).to redirect_to(projects_path)
    end
  end

  describe "GET /projects/new" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get new_project_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in user }

      it "returns http success" do
        get new_project_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /projects" do
    before { sign_in user }

    let(:valid_params) do
      {
        project: {
          title: 'New Project',
          description: 'A great project',
          status: 'open',
          visibility: 'public',
          max_members: 5
        }
      }
    end

    let(:invalid_params) do
      {
        project: {
          title: '',
          description: 'A project without title'
        }
      }
    end

    it "creates a new project with valid params" do
      expect {
        post projects_path, params: valid_params
      }.to change(Project, :count).by(1)

      expect(response).to redirect_to(Project.last)
    end

    it "does not create a project with invalid params" do
      expect {
        post projects_path, params: invalid_params
      }.not_to change(Project, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "sets the current user as owner" do
      post projects_path, params: valid_params
      expect(Project.last.owner).to eq(user)
    end
  end

  describe "GET /projects/:id/edit" do
    before { sign_in user }

    it "returns http success for owner" do
      get edit_project_path(project)
      expect(response).to have_http_status(:success)
    end

    it "redirects non-owner" do
      get edit_project_path(public_project)
      expect(response).to redirect_to(public_project)
    end
  end

  describe "PATCH /projects/:id" do
    before { sign_in user }

    it "updates the project for owner" do
      patch project_path(project), params: { project: { title: 'Updated Title' } }

      expect(response).to redirect_to(project)
      expect(project.reload.title).to eq('Updated Title')
    end

    it "does not update for non-owner" do
      original_title = public_project.title
      patch project_path(public_project), params: { project: { title: 'Hacked Title' } }

      expect(response).to redirect_to(public_project)
      expect(public_project.reload.title).to eq(original_title)
    end
  end

  describe "DELETE /projects/:id" do
    before { sign_in user }

    it "destroys the project for owner" do
      project # create it first
      expect {
        delete project_path(project)
      }.to change(Project, :count).by(-1)

      expect(response).to redirect_to(projects_path)
    end

    it "does not destroy for non-owner" do
      public_project # create it first
      expect {
        delete project_path(public_project)
      }.not_to change(Project, :count)
    end
  end

  describe "POST /projects/:id/join" do
    before { sign_in user }

    it "allows user to join a project" do
      expect {
        post join_project_path(public_project)
      }.to change(Team, :count).by(1)

      expect(response).to redirect_to(public_project)
      expect(public_project.reload.members).to include(user)
    end

    it "does not allow joining twice" do
      create(:team, user: user, project: public_project)

      expect {
        post join_project_path(public_project)
      }.not_to change(Team, :count)

      expect(response).to redirect_to(public_project)
      expect(flash[:alert]).to be_present
    end

    it "does not allow joining a full project" do
      public_project.update!(max_members: 1, current_members_count: 1)

      expect {
        post join_project_path(public_project)
      }.not_to change(Team, :count)

      expect(response).to redirect_to(public_project)
      expect(flash[:alert]).to include('complet')
    end
  end

  describe "DELETE /projects/:id/leave" do
    before { sign_in user }

    it "allows user to leave a project" do
      team = create(:team, user: user, project: public_project)
      public_project.increment!(:current_members_count)

      expect {
        delete leave_project_path(public_project)
      }.to change(Team, :count).by(-1)

      expect(response).to redirect_to(projects_path)
    end

    it "does not allow owner to leave" do
      sign_in other_user
      create(:team, user: other_user, project: public_project)

      delete leave_project_path(public_project)

      expect(response).to redirect_to(public_project)
      expect(flash[:alert]).to include('créateur')
    end

    it "does not allow leaving if not a member" do
      delete leave_project_path(public_project)

      expect(response).to redirect_to(public_project)
      expect(flash[:alert]).to be_present
    end
  end
end
