require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:actor).class_name('User') }
    it { should belong_to(:notifiable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:action) }
  end

  describe 'scopes' do
    let(:user) { create(:user) }

    before do
      create(:notification, user: user, read: false)
      create(:notification, user: user, read: false)
      create(:notification, user: user, read: true)
    end

    it 'returns unread notifications' do
      expect(user.notifications.unread.count).to eq(2)
    end

    it 'orders by most recent first' do
      notifications = user.notifications.recent
      expect(notifications.first.created_at).to be >= notifications.last.created_at
    end
  end

  describe '#mark_as_read!' do
    let(:notification) { create(:notification, read: false) }

    it 'marks notification as read' do
      expect {
        notification.mark_as_read!
      }.to change { notification.reload.read }.from(false).to(true)
    end

    it 'does not update if already read' do
      notification.update(read: true)
      expect(notification).not_to receive(:update)
      notification.mark_as_read!
    end
  end

  describe '#message' do
    it 'returns French message for known actions' do
      notification = build(:notification, action: 'like')
      expect(notification.message).to eq('a aimé votre post')
    end

    it 'returns action string for unknown actions' do
      notification = build(:notification, action: 'custom_action')
      expect(notification.message).to eq('custom_action')
    end
  end
end
