require 'rails_helper'

RSpec.describe Skill, type: :model do
  describe 'associations' do
    it { should have_many(:user_skills).dependent(:destroy) }
    it { should have_many(:users).through(:user_skills) }
    it { should have_many(:project_skills).dependent(:destroy) }
    it { should have_many(:projects).through(:project_skills) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:category) }
    it { should validate_inclusion_of(:category).in_array(Skill::CATEGORIES) }
  end

  describe 'scopes' do
    let!(:backend_skill) { create(:skill, category: 'Backend', name: 'Ruby') }
    let!(:frontend_skill) { create(:skill, category: 'Frontend', name: 'React') }

    describe '.by_category' do
      it 'filters skills by category' do
        expect(Skill.by_category('Backend')).to include(backend_skill)
        expect(Skill.by_category('Backend')).not_to include(frontend_skill)
      end
    end

    describe '.search' do
      it 'finds skills by partial name match' do
        expect(Skill.search('Rub')).to include(backend_skill)
        expect(Skill.search('Rub')).not_to include(frontend_skill)
      end

      it 'is case insensitive' do
        expect(Skill.search('ruby')).to include(backend_skill)
      end
    end
  end
end
