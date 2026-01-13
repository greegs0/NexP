require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:user_skills).dependent(:destroy) }
    it { should have_many(:skills).through(:user_skills) }
    it { should have_many(:owned_projects).class_name('Project').with_foreign_key('owner_id').dependent(:destroy) }
    it { should have_many(:teams).dependent(:destroy) }
    it { should have_many(:projects).through(:teams) }
    it { should have_many(:posts).dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:user_badges).dependent(:destroy) }
    it { should have_many(:badges).through(:user_badges) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:username).is_at_least(3).is_at_most(30) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_length_of(:bio).is_at_most(500) }

    it { should validate_numericality_of(:experience_points).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:level).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(100) }
  end

  describe '#display_name' do
    context 'when name is present' do
      let(:user) { build(:user, name: 'John Doe', username: 'johndoe') }

      it 'returns the name' do
        expect(user.display_name).to eq('John Doe')
      end
    end

    context 'when name is blank' do
      let(:user) { build(:user, name: nil, username: 'johndoe') }

      it 'returns the username' do
        expect(user.display_name).to eq('johndoe')
      end
    end
  end

  describe '#add_experience' do
    let(:user) { create(:user, experience_points: 50, level: 1) }

    it 'increments experience points' do
      expect { user.add_experience(100) }.to change { user.experience_points }.by(100)
    end

    it 'levels up when reaching threshold' do
      expect { user.add_experience(100) }.to change { user.level }.from(1).to(2)
    end
  end

  describe 'scopes' do
    describe '.available' do
      let!(:available_user) { create(:user, available: true) }
      let!(:unavailable_user) { create(:user, available: false) }

      it 'returns only available users' do
        expect(User.available).to include(available_user)
        expect(User.available).not_to include(unavailable_user)
      end
    end
  end

  describe 'callbacks' do
    describe 'normalize_username' do
      it 'converts username to lowercase before save' do
        user = build(:user, username: 'JohnDoe')
        user.save
        expect(user.username).to eq('johndoe')
      end
    end
  end
end
