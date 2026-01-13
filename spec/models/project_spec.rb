require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should belong_to(:owner).class_name('User') }
    it { should have_many(:teams).dependent(:destroy) }
    it { should have_many(:members).through(:teams).source(:user) }
    it { should have_many(:project_skills).dependent(:destroy) }
    it { should have_many(:skills).through(:project_skills) }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(100) }
    it { should validate_length_of(:description).is_at_most(2000) }

    it { should validate_numericality_of(:max_members).is_greater_than(0).is_less_than_or_equal_to(50) }
    it { should validate_numericality_of(:current_members_count).is_greater_than_or_equal_to(0) }

    it { should validate_inclusion_of(:status).in_array(Project::STATUSES) }
    it { should validate_inclusion_of(:visibility).in_array(Project::VISIBILITIES) }
  end

  describe 'custom validations' do
    let(:project) { build(:project) }

    context 'end_date_after_start_date' do
      it 'is invalid when end_date is before start_date' do
        project.start_date = Date.today
        project.end_date = Date.yesterday
        expect(project).not_to be_valid
        expect(project.errors[:end_date]).to include("doit être postérieure à la date de début")
      end

      it 'is valid when end_date is after start_date' do
        project.start_date = Date.today
        project.end_date = Date.tomorrow
        expect(project).to be_valid
      end
    end
  end

  describe '#full?' do
    let(:project) { build(:project, max_members: 5, current_members_count: 5) }

    it 'returns true when at capacity' do
      expect(project.full?).to be true
    end

    it 'returns false when not at capacity' do
      project.current_members_count = 3
      expect(project.full?).to be false
    end
  end

  describe '#accepting_members?' do
    let(:project) { build(:project, status: 'open', visibility: 'public', max_members: 5, current_members_count: 2) }

    it 'returns true when project is accepting' do
      expect(project.accepting_members?).to be true
    end

    it 'returns false when project is full' do
      project.current_members_count = 5
      expect(project.accepting_members?).to be false
    end

    it 'returns false when project is completed' do
      project.status = 'completed'
      expect(project.accepting_members?).to be false
    end

    it 'returns false when project is private' do
      project.visibility = 'private'
      expect(project.accepting_members?).to be false
    end
  end

  describe '#member?' do
    let(:owner) { create(:user) }
    let(:member) { create(:user) }
    let(:non_member) { create(:user) }
    let(:project) { create(:project, owner: owner) }

    before do
      create(:team, user: member, project: project)
    end

    it 'returns true for owner' do
      expect(project.member?(owner)).to be true
    end

    it 'returns true for member' do
      expect(project.member?(member)).to be true
    end

    it 'returns false for non-member' do
      expect(project.member?(non_member)).to be false
    end
  end

  describe 'scopes' do
    let!(:public_project) { create(:project, visibility: 'public') }
    let!(:private_project) { create(:project, visibility: 'private') }

    describe '.public_projects' do
      it 'returns only public projects' do
        expect(Project.public_projects).to include(public_project)
        expect(Project.public_projects).not_to include(private_project)
      end
    end

    describe '.available' do
      let!(:full_project) { create(:project, max_members: 2, current_members_count: 2) }
      let!(:available_project) { create(:project, max_members: 5, current_members_count: 2, status: 'open') }

      it 'returns only available projects' do
        expect(Project.available).to include(available_project)
        expect(Project.available).not_to include(full_project)
      end
    end
  end
end
