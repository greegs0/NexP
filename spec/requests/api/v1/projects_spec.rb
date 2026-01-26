require 'rails_helper'

RSpec.describe 'Api::V1::Projects', type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/projects' do
    let!(:public_project) { create(:project, visibility: 'public', status: 'open') }
    let!(:private_project) { create(:project, visibility: 'private', status: 'open') }

    context 'without authentication' do
      it 'returns public projects' do
        get '/api/v1/projects'

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['projects'].length).to eq(1)
        expect(json['projects'].first['id']).to eq(public_project.id)
      end
    end

    context 'with filters' do
      let!(:rails_skill) { create(:skill, name: 'Ruby on Rails') }
      let!(:rails_project) { create(:project, visibility: 'public', status: 'open') }

      before do
        rails_project.skills << rails_skill
      end

      it 'filters by skill' do
        get '/api/v1/projects', params: { skill_id: rails_skill.id }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['projects'].map { |p| p['id'] }).to include(rails_project.id)
      end

      it 'filters by status' do
        completed_project = create(:project, visibility: 'public', status: 'completed')

        get '/api/v1/projects', params: { status: 'completed' }

        json = JSON.parse(response.body)
        expect(json['projects'].map { |p| p['id'] }).to include(completed_project.id)
        expect(json['projects'].map { |p| p['id'] }).not_to include(public_project.id)
      end
    end
  end

  describe 'GET /api/v1/projects/:id' do
    let!(:project) { create(:project, visibility: 'public') }

    it 'returns project details' do
      get "/api/v1/projects/#{project.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['project']['id']).to eq(project.id)
      expect(json['project']['title']).to eq(project.title)
      expect(json['project']['owner']).to be_present
    end
  end

  describe 'POST /api/v1/projects' do
    context 'with valid data' do
      let(:skill) { create(:skill) }

      it 'creates a new project' do
        expect {
          post '/api/v1/projects', params: {
            project: {
              title: 'New Project',
              description: 'A great project',
              status: 'open',
              visibility: 'public',
              max_members: 5
            },
            skill_ids: [skill.id]
          }, headers: headers
        }.to change(Project, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['project']['title']).to eq('New Project')
        expect(json['project']['skills'].map { |s| s['id'] }).to include(skill.id)
      end
    end

    context 'without authentication' do
      it 'returns unauthorized error' do
        post '/api/v1/projects', params: {
          project: { title: 'New Project' }
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid data' do
      it 'returns validation errors' do
        post '/api/v1/projects', params: {
          project: { title: 'AB' } # Too short
        }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end
  end

  describe 'PATCH /api/v1/projects/:id' do
    let(:project) { create(:project, owner: user) }

    context 'as owner' do
      it 'updates the project' do
        patch "/api/v1/projects/#{project.id}", params: {
          project: { title: 'Updated Title' }
        }, headers: headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['project']['title']).to eq('Updated Title')
        expect(project.reload.title).to eq('Updated Title')
      end
    end

    context 'as non-owner' do
      let(:other_user) { create(:user) }
      let(:other_token) { JsonWebToken.encode(user_id: other_user.id) }
      let(:other_headers) { { 'Authorization' => "Bearer #{other_token}" } }

      it 'returns forbidden error' do
        patch "/api/v1/projects/#{project.id}", params: {
          project: { title: 'Hacked Title' }
        }, headers: other_headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /api/v1/projects/:id' do
    let(:project) { create(:project, owner: user) }

    context 'as owner' do
      it 'deletes the project' do
        project # Create it first

        expect {
          delete "/api/v1/projects/#{project.id}", headers: headers
        }.to change(Project, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'as non-owner' do
      let(:other_user) { create(:user) }
      let(:other_token) { JsonWebToken.encode(user_id: other_user.id) }
      let(:other_headers) { { 'Authorization' => "Bearer #{other_token}" } }

      it 'returns forbidden error' do
        delete "/api/v1/projects/#{project.id}", headers: other_headers

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /api/v1/projects/:id/join' do
    let(:project) { create(:project, visibility: 'public', status: 'open', current_members_count: 1, max_members: 5) }

    context 'when project is available' do
      it 'adds user to project' do
        expect {
          post "/api/v1/projects/#{project.id}/join", headers: headers
        }.to change { project.reload.current_members_count }.by(1)

        expect(response).to have_http_status(:ok)
        expect(project.members).to include(user)
      end
    end

    context 'when project is full' do
      before do
        project.update(current_members_count: 5)
      end

      it 'returns error' do
        post "/api/v1/projects/#{project.id}/join", headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to match(/complet/)
      end
    end

    context 'when already a member' do
      before do
        create(:team, user: user, project: project, status: 'accepted')
      end

      it 'returns error' do
        post "/api/v1/projects/#{project.id}/join", headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/projects/:id/leave' do
    let(:project) { create(:project, visibility: 'public', status: 'open', current_members_count: 2) }

    before do
      create(:team, user: user, project: project, status: 'accepted')
    end

    context 'as member' do
      it 'removes user from project' do
        expect {
          delete "/api/v1/projects/#{project.id}/leave", headers: headers
        }.to change { project.reload.current_members_count }.by(-1)

        expect(response).to have_http_status(:ok)
        expect(project.members).not_to include(user)
      end
    end

    context 'as owner' do
      let(:owned_project) { create(:project, owner: user, current_members_count: 1) }

      it 'returns error' do
        delete "/api/v1/projects/#{owned_project.id}/leave", headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
