require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:bookmarks).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(1).is_at_most(5000) }
  end

  describe 'XSS protection' do
    it 'sanitizes HTML content before saving' do
      post = create(:post, content: '<script>alert("XSS")</script>Hello')
      # Le sanitizer supprime les balises HTML mais garde le texte
      # Cela empêche l'exécution de scripts car les balises sont supprimées
      expect(post.content).not_to include('<script>')
      expect(post.content).not_to include('</script>')
    end

    it 'allows plain text' do
      post = create(:post, content: 'This is a normal post')
      expect(post.content).to eq('This is a normal post')
    end
  end

  describe 'counter caches' do
    let(:post) { create(:post) }

    it 'increments likes_count when liked' do
      expect {
        create(:like, post: post)
      }.to change { post.reload.likes_count }.by(1)
    end

    it 'increments comments_count when commented' do
      expect {
        create(:comment, post: post)
      }.to change { post.reload.comments_count }.by(1)
    end
  end
end
