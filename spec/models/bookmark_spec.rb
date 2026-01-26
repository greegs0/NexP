require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:bookmarkable) }
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    before { create(:bookmark, user: user, bookmarkable: post) }

    it 'validates uniqueness of user_id scoped to bookmarkable' do
      duplicate_bookmark = build(:bookmark, user: user, bookmarkable: post)
      expect(duplicate_bookmark).not_to be_valid
    end

    it 'allows same user to bookmark different items' do
      another_post = create(:post)
      bookmark = build(:bookmark, user: user, bookmarkable: another_post)
      expect(bookmark).to be_valid
    end

    it 'allows different users to bookmark the same item' do
      another_user = create(:user)
      bookmark = build(:bookmark, user: another_user, bookmarkable: post)
      expect(bookmark).to be_valid
    end
  end

  describe 'polymorphic bookmarkable' do
    let(:user) { create(:user) }

    it 'can bookmark a post' do
      post = create(:post)
      bookmark = create(:bookmark, user: user, bookmarkable: post)
      expect(bookmark.bookmarkable_type).to eq('Post')
    end

    it 'can bookmark a project' do
      project = create(:project)
      bookmark = create(:bookmark, user: user, bookmarkable: project)
      expect(bookmark.bookmarkable_type).to eq('Project')
    end
  end
end
