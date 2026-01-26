require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(1).is_at_most(2000) }
  end

  describe 'XSS protection' do
    it 'sanitizes HTML content before saving' do
      comment = create(:comment, content: '<script>alert("XSS")</script>Comment')
      expect(comment.content).to eq('Comment')
      expect(comment.content).not_to include('<script>')
    end
  end
end
