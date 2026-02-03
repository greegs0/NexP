require 'rails_helper'

RSpec.describe ExperienceService, type: :service do
  let(:user) { create(:user, experience_points: 0) }
  let(:target_user) { create(:user, experience_points: 0) }

  describe '.award' do
    it 'awards XP for post_created action' do
      expect {
        ExperienceService.award(user: user, action: :post_created)
      }.to change { user.reload.experience_points }.by(10)
    end

    it 'awards XP for comment_created action' do
      expect {
        ExperienceService.award(user: user, action: :comment_created)
      }.to change { user.reload.experience_points }.by(5)
    end

    it 'awards XP for message_sent action' do
      expect {
        ExperienceService.award(user: user, action: :message_sent)
      }.to change { user.reload.experience_points }.by(3)
    end

    it 'awards XP for follow_given action' do
      expect {
        ExperienceService.award(user: user, action: :follow_given)
      }.to change { user.reload.experience_points }.by(5)
    end

    it 'awards XP for like_given action' do
      expect {
        ExperienceService.award(user: user, action: :like_given)
      }.to change { user.reload.experience_points }.by(2)
    end

    it 'returns true when XP is awarded' do
      result = ExperienceService.award(user: user, action: :post_created)
      expect(result).to be true
    end

    it 'returns false for unknown action' do
      result = ExperienceService.award(user: user, action: :unknown_action)
      expect(result).to be false
    end

    it 'does not award XP for unknown action' do
      expect {
        ExperienceService.award(user: user, action: :unknown_action)
      }.not_to change { user.reload.experience_points }
    end
  end

  describe '.award_with_notification' do
    let(:post) { create(:post, user: target_user) }

    it 'awards XP to the actor' do
      expect {
        ExperienceService.award_with_notification(
          actor: user,
          action: :like_given,
          target_user: target_user,
          notifiable: post
        )
      }.to change { user.reload.experience_points }.by(2)
    end

    it 'awards XP to the target user' do
      expect {
        ExperienceService.award_with_notification(
          actor: user,
          action: :like_given,
          target_user: target_user,
          notifiable: post
        )
      }.to change { target_user.reload.experience_points }.by(5) # like_received
    end

    it 'creates a like notification for the target user' do
      expect {
        ExperienceService.award_with_notification(
          actor: user,
          action: :like_given,
          target_user: target_user,
          notifiable: post
        )
      }.to change { Notification.where(user: target_user, action: 'like').count }.by(1)
    end

    it 'does not create like notification when actor is target' do
      expect {
        ExperienceService.award_with_notification(
          actor: user,
          action: :like_given,
          target_user: user,
          notifiable: post
        )
      }.not_to change { Notification.where(action: 'like').count }
    end
  end

  describe 'XP_VALUES constant' do
    it 'defines all expected actions' do
      expected_actions = %i[
        post_created comment_created message_sent
        follow_given like_given
        comment_received like_received
      ]
      expect(ExperienceService::XP_VALUES.keys).to match_array(expected_actions)
    end
  end

  describe 'NOTIFICATION_ACTIONS constant' do
    it 'maps actions to notification types' do
      expect(ExperienceService::NOTIFICATION_ACTIONS[:follow_given]).to eq('follow')
      expect(ExperienceService::NOTIFICATION_ACTIONS[:like_given]).to eq('like')
      expect(ExperienceService::NOTIFICATION_ACTIONS[:comment_created]).to eq('comment')
      expect(ExperienceService::NOTIFICATION_ACTIONS[:message_sent]).to eq('message')
    end
  end
end
