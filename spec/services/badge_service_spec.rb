require 'rails_helper'

RSpec.describe BadgeService, type: :service do
  let(:user) { create(:user, experience_points: 0, level: 1) }

  describe '.check_and_award_badges' do
    context 'level badges' do
      before do
        create(:badge, name: 'Débutant', xp_required: 0)
        create(:badge, name: 'Novice', xp_required: 500)
        create(:badge, name: 'Intermédiaire', xp_required: 1000)
      end

      it 'awards badge when XP requirement is met' do
        user.update(experience_points: 550, level: 6)

        expect {
          BadgeService.check_and_award_badges(user)
        }.to change { user.badges.count }.by_at_least(1)

        expect(user.badges.pluck(:name)).to include('Débutant', 'Novice')
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
      before do
        create(:badge, name: 'Premier Projet', xp_required: nil)
        create(:badge, name: 'Entrepreneur', xp_required: nil)
      end

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
      before do
        create(:badge, name: 'Premier Post', xp_required: nil)
        create(:badge, name: 'Blogueur', xp_required: nil)
      end

      it 'awards first post badge' do
        create(:post, user: user)

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Premier Post')
      end

      it 'awards blogger badge for many posts' do
        10.times { create(:post, user: user) }

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Blogueur')
      end
    end

    context 'activity badges' do
      before do
        create(:badge, name: 'Polyvalent', xp_required: nil)
        create(:badge, name: 'Communicateur', xp_required: nil)
      end

      it 'awards polyvalent badge for many skills' do
        10.times { user.skills << create(:skill) }

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Polyvalent')
      end

      it 'awards communicator badge for many messages' do
        project = create(:project)
        50.times { create(:message, sender: user, project: project) }

        BadgeService.check_and_award_badges(user)

        expect(user.badges.pluck(:name)).to include('Communicateur')
      end
    end
  end
end
