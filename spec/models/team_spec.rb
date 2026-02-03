require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end

  describe 'validations' do
    subject { create(:team, user: user, project: project) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:project_id) }
    it { should validate_inclusion_of(:status).in_array(%w[pending accepted rejected]) }

    it 'prevents duplicate user-project combination' do
      create(:team, user: user, project: project)
      duplicate = build(:team, user: user, project: project)

      expect(duplicate).not_to be_valid
    end

    it 'allows same user in different projects' do
      create(:team, user: user, project: project)
      other_project = create(:project)
      different_project_team = build(:team, user: user, project: other_project)

      expect(different_project_team).to be_valid
    end

    it 'allows different users in same project' do
      create(:team, user: user, project: project)
      other_user = create(:user)
      different_user_team = build(:team, user: other_user, project: project)

      expect(different_user_team).to be_valid
    end
  end

  describe 'scopes' do
    let!(:accepted_team) { create(:team, user: user, project: project, status: 'accepted') }
    let!(:pending_team) { create(:team, user: create(:user), project: project, status: 'pending') }
    let!(:rejected_team) { create(:team, user: create(:user), project: project, status: 'rejected') }

    describe '.accepted' do
      it 'returns only accepted teams' do
        expect(Team.accepted).to include(accepted_team)
        expect(Team.accepted).not_to include(pending_team, rejected_team)
      end
    end

    describe '.pending' do
      it 'returns only pending teams' do
        expect(Team.pending).to include(pending_team)
        expect(Team.pending).not_to include(accepted_team, rejected_team)
      end
    end

    describe '.rejected' do
      it 'returns only rejected teams' do
        expect(Team.rejected).to include(rejected_team)
        expect(Team.rejected).not_to include(accepted_team, pending_team)
      end
    end
  end

  describe 'status transitions' do
    let(:team) { create(:team, user: user, project: project, status: 'pending') }

    it 'can transition from pending to accepted' do
      team.update(status: 'accepted')
      expect(team.reload.status).to eq('accepted')
    end

    it 'can transition from pending to rejected' do
      team.update(status: 'rejected')
      expect(team.reload.status).to eq('rejected')
    end

    it 'rejects invalid status' do
      team.status = 'invalid_status'
      expect(team).not_to be_valid
    end
  end
end
