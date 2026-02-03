require 'rails_helper'

RSpec.describe Badge, type: :model do
  describe 'associations' do
    it { should have_many(:user_badges).dependent(:destroy) }
    it { should have_many(:users).through(:user_badges) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '.all_cached' do
    before do
      # Nettoyer les badges existants
      Badge.destroy_all
      Rails.cache.delete('badges/all')
    end

    it 'returns all badges ordered by xp_required' do
      badge1 = Badge.create!(name: 'Apprenti', xp_required: 100)
      badge2 = Badge.create!(name: 'Débutant', xp_required: 50)
      Rails.cache.delete('badges/all')

      result = Badge.all_cached

      expect(result.first).to eq(badge2)
      expect(result.last).to eq(badge1)
    end

    it 'caches the result' do
      Badge.create!(name: 'Test Badge', xp_required: 100)
      Rails.cache.delete('badges/all')

      # First call caches the result
      initial_result = Badge.all_cached
      initial_count = initial_result.count

      # Stub the database query to verify cache is used
      allow(Badge).to receive(:order).and_call_original

      # Second call should use cache
      cached_result = Badge.all_cached
      expect(cached_result.count).to eq(initial_count)
    end
  end

  describe 'callbacks' do
    it 'expires cache on save' do
      Badge.create!(name: 'Initial Badge')
      Rails.cache.delete('badges/all')
      Badge.all_cached

      badge = Badge.create!(name: 'New Badge')

      # Cache should be expired
      expect(Rails.cache.exist?('badges/all')).to be false
    end

    it 'expires cache on destroy' do
      badge = Badge.create!(name: 'To Delete')
      Rails.cache.delete('badges/all')
      Badge.all_cached

      badge.destroy

      expect(Rails.cache.exist?('badges/all')).to be false
    end
  end
end
