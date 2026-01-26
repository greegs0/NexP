require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe 'associations' do
    it { should belong_to(:follower).class_name('User') }
    it { should belong_to(:following).class_name('User') }
  end

  describe 'validations' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    before { create(:follow, follower: user1, following: user2) }

    it 'validates uniqueness of follower_id scoped to following_id' do
      duplicate_follow = build(:follow, follower: user1, following: user2)
      expect(duplicate_follow).not_to be_valid
    end

    it 'prevents user from following themselves' do
      self_follow = build(:follow, follower: user1, following: user1)
      expect(self_follow).not_to be_valid
      expect(self_follow.errors[:base]).to include('Vous ne pouvez pas vous suivre vous-même')
    end
  end

  describe 'user helper methods' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    describe '#follow' do
      it 'creates a follow relationship' do
        expect {
          user1.follow(user2)
        }.to change { user1.following.count }.by(1)
      end

      it 'does not allow self-follow' do
        expect {
          user1.follow(user1)
        }.not_to change { user1.following.count }
      end
    end

    describe '#unfollow' do
      before { user1.follow(user2) }

      it 'destroys the follow relationship' do
        expect {
          user1.unfollow(user2)
        }.to change { user1.following.count }.by(-1)
      end
    end

    describe '#following?' do
      it 'returns true when following' do
        user1.follow(user2)
        expect(user1.following?(user2)).to be true
      end

      it 'returns false when not following' do
        expect(user1.following?(user2)).to be false
      end
    end
  end
end
