require 'rails_helper'

RSpec.describe BadgeService, type: :service do
  let(:user) { create(:user, experience_points: 0, level: 1) }

  describe '.check_and_award_badges' do
    context 'level badges' do
      it 'awards badge when level requirement is met' do
        user.update(experience_points: 550, level: 6)

        expect {
          BadgeService.check_and_award_badges(user)
        }.to change { user.badges.count }.by_at_least(1)

        # Le service crée les badges si inexistants
        expect(user.badges.pluck(:name)).to include('Débutant', 'Apprenti')
      end

      it 'does not award same badge twice' do
        user.update(experience_points: 1200, level: 13)
        BadgeService.check_and_award_badges(user)

        initial_count = user.badges.count

        BadgeService.check_and_award_badges(user)

        expect(user.badges.count).to eq(initial_count)
      end
    end

    context 'project badges' do
      it 'awards first project badge' do
        create(:project, owner: user)

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Premier Projet')
      end

      it 'awards entrepreneur badge for multiple projects' do
        5.times { create(:project, owner: user) }

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Entrepreneur')
      end
    end

    context 'social badges' do
      it 'awards first post badge' do
        create(:post, user: user)

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Première Publication')
      end

      it 'awards blogger badge for many posts' do
        10.times { create(:post, user: user) }

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Blogueur')
      end
    end

    context 'activity badges' do
      it 'awards polyvalent badge for many skills' do
        5.times { user.skills << create(:skill) }

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Polyvalent')
      end

      it 'awards communicator badge for many messages' do
        project = create(:project)
        50.times { create(:message, :project_message, sender: user, project: project) }

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Communicateur')
      end
    end

    context 'notifications' do
      it 'creates notification when badge is awarded' do
        create(:post, user: user)

        expect {
          BadgeService.check_and_award_badges(user)
        }.to change { Notification.where(user: user, action: 'badge_earned').count }.by_at_least(1)
      end
    end
  end
end
