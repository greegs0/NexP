require 'rails_helper'

RSpec.describe DashboardDataService, type: :service do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  subject { described_class.new(user) }

  describe '#stats' do
    it 'returns a hash with stats' do
      stats = subject.stats
      expect(stats).to include(
        :total_skills,
        :total_projects,
        :total_owned_projects,
        :total_badges
      )
    end

    it 'counts user skills' do
      3.times { user.skills << create(:skill) }
      expect(subject.stats[:total_skills]).to eq(3)
    end

    it 'counts user projects' do
      2.times { create(:project, owner: other_user).members << user }
      expect(subject.stats[:total_projects]).to eq(2)
    end

    it 'counts user owned projects' do
      2.times { create(:project, owner: user) }
      expect(subject.stats[:total_owned_projects]).to eq(2)
    end

    it 'counts user badges' do
      badge = Badge.create!(name: 'Test Badge', description: 'Test')
      UserBadge.create!(user: user, badge: badge)
      expect(subject.stats[:total_badges]).to eq(1)
    end

    it 'memoizes the result' do
      first_call = subject.stats
      second_call = subject.stats
      expect(first_call).to equal(second_call)
    end
  end

  describe '#recent_projects' do
    it 'returns projects the user is member of' do
      project = create(:project, owner: other_user)
      project.members << user
      expect(subject.recent_projects).to include(project)
    end

    it 'limits to 3 projects' do
      5.times do
        project = create(:project, owner: other_user)
        project.members << user
      end
      expect(subject.recent_projects.count).to eq(3)
    end

    it 'orders by created_at desc' do
      old_project = create(:project, owner: other_user, created_at: 2.days.ago)
      new_project = create(:project, owner: other_user, created_at: 1.day.ago)
      old_project.members << user
      new_project.members << user

      expect(subject.recent_projects.first).to eq(new_project)
    end
  end

  describe '#owned_projects' do
    it 'returns projects owned by user' do
      project = create(:project, owner: user)
      expect(subject.owned_projects).to include(project)
    end

    it 'limits to 3 projects' do
      5.times { create(:project, owner: user) }
      expect(subject.owned_projects.count).to eq(3)
    end
  end

  describe '#active_projects' do
    it 'returns projects with open or in_progress status' do
      open_project = create(:project, owner: other_user, status: 'open')
      in_progress = create(:project, owner: other_user, status: 'in_progress')
      completed = create(:project, owner: other_user, status: 'completed')
      [open_project, in_progress, completed].each { |p| p.members << user }

      active = subject.active_projects
      expect(active).to include(open_project, in_progress)
      expect(active).not_to include(completed)
    end

    it 'limits to 4 projects' do
      6.times do
        project = create(:project, owner: other_user, status: 'open')
        project.members << user
      end
      expect(subject.active_projects.count).to eq(4)
    end
  end

  describe '#upcoming_deadlines' do
    it 'returns projects with deadlines in next 30 days' do
      upcoming = create(:project, owner: other_user, deadline: 10.days.from_now)
      far_away = create(:project, owner: other_user, deadline: 60.days.from_now)
      no_deadline = create(:project, owner: other_user, deadline: nil)
      [upcoming, far_away, no_deadline].each { |p| p.members << user }

      deadlines = subject.upcoming_deadlines
      expect(deadlines).to include(upcoming)
      expect(deadlines).not_to include(far_away, no_deadline)
    end

    it 'orders by deadline asc' do
      later = create(:project, owner: other_user, deadline: 20.days.from_now)
      sooner = create(:project, owner: other_user, deadline: 5.days.from_now)
      [later, sooner].each { |p| p.members << user }

      expect(subject.upcoming_deadlines.first).to eq(sooner)
    end

    it 'limits to 5 projects' do
      7.times do |i|
        project = create(:project, owner: other_user, deadline: (i + 1).days.from_now)
        project.members << user
      end
      expect(subject.upcoming_deadlines.count).to eq(5)
    end
  end

  describe '#recent_skills' do
    it 'returns user skills' do
      skill = create(:skill)
      user.skills << skill
      expect(subject.recent_skills).to include(skill)
    end

    it 'limits to 5 skills' do
      7.times { user.skills << create(:skill) }
      expect(subject.recent_skills.count).to eq(5)
    end
  end

  describe '#recent_notifications' do
    it 'returns user notifications' do
      notification = create(:notification, user: user, actor: other_user)
      expect(subject.recent_notifications).to include(notification)
    end

    it 'limits to 5 notifications' do
      7.times { create(:notification, user: user, actor: other_user) }
      expect(subject.recent_notifications.count).to eq(5)
    end
  end

  describe '#unread_notifications_count' do
    it 'counts unread notifications' do
      create(:notification, user: user, actor: other_user, read: false)
      create(:notification, user: user, actor: other_user, read: false)
      create(:notification, user: user, actor: other_user, read: true)

      expect(subject.unread_notifications_count).to eq(2)
    end
  end

  describe '#unread_messages' do
    it 'returns unread messages for user' do
      message = create(:message, sender: other_user, recipient: user, project: nil, read_at: nil)
      expect(subject.unread_messages).to include(message)
    end

    it 'excludes read messages' do
      read_message = create(:message, sender: other_user, recipient: user, project: nil, read_at: Time.current)
      expect(subject.unread_messages).not_to include(read_message)
    end

    it 'limits to 3 messages' do
      5.times { create(:message, sender: other_user, recipient: user, project: nil, read_at: nil) }
      expect(subject.unread_messages.count).to eq(3)
    end
  end

  describe '#unread_messages_count' do
    it 'counts unread messages' do
      2.times { create(:message, sender: other_user, recipient: user, project: nil, read_at: nil) }
      create(:message, sender: other_user, recipient: user, project: nil, read_at: Time.current)

      expect(subject.unread_messages_count).to eq(2)
    end
  end

  describe '#user_badges' do
    it 'returns user badges' do
      badge = Badge.create!(name: 'Test Badge', description: 'Test')
      UserBadge.create!(user: user, badge: badge)
      expect(subject.user_badges).to include(badge)
    end

    it 'limits to 6 badges' do
      8.times do |i|
        badge = Badge.create!(name: "Badge #{i}", description: 'Test')
        UserBadge.create!(user: user, badge: badge)
      end
      expect(subject.user_badges.count).to eq(6)
    end
  end

  describe '#xp_progression' do
    it 'returns an array of 7 values' do
      expect(subject.xp_progression.length).to eq(7)
    end

    it 'returns numeric values' do
      subject.xp_progression.each do |value|
        expect(value).to be_a(Numeric)
      end
    end

    it 'returns increasing values' do
      progression = subject.xp_progression
      progression.each_cons(2) do |a, b|
        expect(b).to be >= a
      end
    end
  end
end
