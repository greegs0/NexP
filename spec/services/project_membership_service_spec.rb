require 'rails_helper'

RSpec.describe ProjectMembershipService, type: :service do
  let(:owner) { create(:user) }
  let(:user) { create(:user) }
  let(:project) { create(:project, owner: owner, max_members: 5, current_members_count: 1) }

  subject { described_class.new(project, user) }

  describe '#join' do
    context 'when user can join' do
      it 'creates a team membership' do
        expect { subject.join }.to change { project.teams.count }.by(1)
      end

      it 'increments the current_members_count' do
        expect { subject.join }.to change { project.reload.current_members_count }.by(1)
      end

      it 'returns the created team' do
        team = subject.join
        expect(team).to be_a(Team)
        expect(team.user).to eq(user)
        expect(team.project).to eq(project)
      end

      it 'sets the correct role' do
        team = subject.join
        expect(team.role).to eq('member')
      end

      it 'sets the correct status' do
        team = subject.join
        expect(team.status).to eq('accepted')
      end

      it 'sets joined_at timestamp' do
        team = subject.join
        expect(team.joined_at).to be_present
      end
    end

    context 'when user is already a member' do
      before { subject.join }

      it 'raises AlreadyMemberError' do
        expect { subject.join }.to raise_error(
          ProjectMembershipService::AlreadyMemberError,
          "Vous êtes déjà membre de ce projet."
        )
      end
    end

    context 'when project is full' do
      let(:project) { create(:project, owner: owner, max_members: 1, current_members_count: 1) }

      it 'raises ProjectFullError' do
        expect { subject.join }.to raise_error(
          ProjectMembershipService::ProjectFullError,
          "Ce projet est complet."
        )
      end
    end
  end

  describe '#leave' do
    context 'when user is a member' do
      before { subject.join }

      it 'destroys the team membership' do
        expect { subject.leave }.to change { project.teams.count }.by(-1)
      end

      it 'decrements the current_members_count' do
        expect { subject.leave }.to change { project.reload.current_members_count }.by(-1)
      end

      it 'returns true' do
        expect(subject.leave).to be true
      end
    end

    context 'when user is not a member' do
      let(:non_member) { create(:user) }

      it 'raises NotMemberError' do
        service = described_class.new(project, non_member)
        expect { service.leave }.to raise_error(
          ProjectMembershipService::NotMemberError,
          "Vous ne faites pas partie de ce projet."
        )
      end
    end

    context 'when user is the owner' do
      before do
        # Owner needs a team record to reach the owner check
        project.teams.create!(user: owner, role: 'owner', status: 'accepted')
      end

      it 'raises OwnerCannotLeaveError' do
        service = described_class.new(project, owner)
        expect { service.leave }.to raise_error(
          ProjectMembershipService::OwnerCannotLeaveError,
          "Le créateur ne peut pas quitter son propre projet."
        )
      end
    end
  end

  describe '#member?' do
    it 'returns false when user is not a member' do
      expect(subject.member?).to be false
    end

    it 'returns true when user is a member' do
      subject.join
      expect(subject.member?).to be true
    end
  end

  describe '#owner?' do
    it 'returns false when user is not the owner' do
      expect(subject.owner?).to be false
    end

    it 'returns true when user is the owner' do
      service = described_class.new(project, owner)
      expect(service.owner?).to be true
    end
  end

  describe '#project_full?' do
    it 'returns false when project has space' do
      expect(subject.project_full?).to be false
    end

    it 'returns true when project is at capacity' do
      project.update(current_members_count: project.max_members)
      expect(subject.project_full?).to be true
    end
  end

  describe '#can_join?' do
    it 'returns true when user can join' do
      expect(subject.can_join?).to be true
    end

    it 'returns false when user is already a member' do
      subject.join
      expect(subject.can_join?).to be false
    end

    it 'returns false when project is full' do
      project.update(current_members_count: project.max_members)
      expect(subject.can_join?).to be false
    end
  end

  describe '#can_leave?' do
    it 'returns false when user is not a member' do
      expect(subject.can_leave?).to be false
    end

    it 'returns true when user is a member' do
      subject.join
      expect(subject.can_leave?).to be true
    end

    it 'returns false when user is the owner' do
      service = described_class.new(project, owner)
      expect(service.can_leave?).to be false
    end
  end
end
