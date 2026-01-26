require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    before { create(:like, user: user, post: post) }

    it 'validates uniqueness of user_id scoped to post_id' do
      duplicate_like = build(:like, user: user, post: post)
      expect(duplicate_like).not_to be_valid
      expect(duplicate_like.errors[:user_id]).to include('has already been taken')
    end

    it 'allows same user to like different posts' do
      another_post = create(:post)
      like = build(:like, user: user, post: another_post)
      expect(like).to be_valid
    end

    it 'allows different users to like the same post' do
      another_user = create(:user)
      like = build(:like, user: another_user, post: post)
      expect(like).to be_valid
    end
  end
end
