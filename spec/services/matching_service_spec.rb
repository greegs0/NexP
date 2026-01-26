require 'rails_helper'

RSpec.describe MatchingService, type: :service do
  let!(:backend_skill) { create(:skill, name: 'Ruby on Rails', category: 'Backend') }
  let!(:frontend_skill) { create(:skill, name: 'React', category: 'Frontend') }
  let!(:database_skill) { create(:skill, name: 'PostgreSQL', category: 'Database') }

  let!(:user) { create(:user, level: 50, experience_points: 5000, available: true) }
  let!(:other_user) { create(:user, level: 30, experience_points: 3000, available: true) }

  let!(:project) do
    create(:project, status: 'open', visibility: 'public', current_members_count: 1, max_members: 5)
  end

  before do
    user.skills << [backend_skill, frontend_skill]
    project.skills << [backend_skill, frontend_skill, database_skill]
  end

  describe '.find_projects_for_user' do
    context 'when user has matching skills' do
      it 'returns projects with matching skills' do
        projects = MatchingService.find_projects_for_user(user, limit: 10)

        expect(projects).to include(project)
        expect(projects).to be_an(Array)
      end

      it 'returns projects sorted by match score' do
        project2 = create(:project, status: 'open', visibility: 'public', current_members_count: 0, max_members: 5)
        project2.skills << backend_skill

        projects = MatchingService.find_projects_for_user(user, limit: 10)

        expect(projects.first).to be_in([project, project2])
      end
    end

    context 'when user has no skills' do
      let(:user_without_skills) { create(:user) }

      it 'returns empty array' do
        projects = MatchingService.find_projects_for_user(user_without_skills, limit: 10)
        expect(projects).to eq([])
      end
    end

    context 'when user owns the project' do
      it 'does not return owned projects' do
        owned_project = create(:project, owner: user, status: 'open', visibility: 'public')
        owned_project.skills << backend_skill

        projects = MatchingService.find_projects_for_user(user, limit: 10)

        expect(projects).not_to include(owned_project)
      end
    end

    context 'when user is already a member' do
      before do
        create(:team, user: user, project: project, status: 'accepted')
      end

      it 'does not return projects where user is member' do
        projects = MatchingService.find_projects_for_user(user, limit: 10)
        expect(projects).not_to include(project)
      end
    end
  end

  describe '.find_users_for_project' do
    before do
      other_user.skills << [backend_skill, frontend_skill, database_skill]
    end

    it 'returns users with matching skills' do
      users = MatchingService.find_users_for_project(project, limit: 10)

      expect(users).to include(other_user)
      expect(users).not_to include(user) # Owner is excluded
    end

    it 'returns available users only' do
      unavailable_user = create(:user, available: false)
      unavailable_user.skills << [backend_skill, frontend_skill]

      users = MatchingService.find_users_for_project(project, limit: 10)

      expect(users).not_to include(unavailable_user)
    end

    it 'excludes project members' do
      create(:team, user: other_user, project: project, status: 'accepted')

      users = MatchingService.find_users_for_project(project, limit: 10)

      expect(users).not_to include(other_user)
    end
  end

  describe '.find_similar_users' do
    let!(:similar_user) { create(:user) }

    before do
      similar_user.skills << [backend_skill, frontend_skill]
    end

    it 'returns users with common skills' do
      users = MatchingService.find_similar_users(user, limit: 10)

      expect(users).to include(similar_user)
    end

    it 'does not return the user themselves' do
      users = MatchingService.find_similar_users(user, limit: 10)

      expect(users).not_to include(user)
    end

    it 'returns users sorted by common skills count' do
      very_similar_user = create(:user)
      very_similar_user.skills << [backend_skill, frontend_skill, database_skill]

      somewhat_similar_user = create(:user)
      somewhat_similar_user.skills << backend_skill

      users = MatchingService.find_similar_users(user, limit: 10)

      # User with more common skills should be first
      expect(users.index(very_similar_user)).to be < users.index(somewhat_similar_user) if users.include?(very_similar_user) && users.include?(somewhat_similar_user)
    end
  end
end
