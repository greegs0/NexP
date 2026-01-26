require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }
  let(:actor) { create(:user) }

  before { sign_in user }

  describe "GET /notifications" do
    before do
      create_list(:notification, 3, user: user, actor: actor, read: false)
      create_list(:notification, 2, user: user, actor: actor, read: true)
    end

    it "returns success" do
      get notifications_path
      expect(response).to have_http_status(:success)
    end

    it "displays notifications" do
      get notifications_path
      expect(response.body).to include(actor.display_name)
    end

    it "marks displayed notifications as read" do
      expect {
        get notifications_path
      }.to change { user.notifications.unread.count }.from(3).to(0)
    end
  end

  describe "GET /notifications/unread_count" do
    before do
      create_list(:notification, 5, user: user, actor: actor, read: false)
    end

    it "returns JSON with count" do
      get unread_count_notifications_path
      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('application/json')
      expect(JSON.parse(response.body)['count']).to eq(5)
    end
  end

  describe "DELETE /notifications/:id" do
    let!(:notification) { create(:notification, user: user, actor: actor) }

    it "destroys the notification" do
      expect {
        delete notification_path(notification)
      }.to change(Notification, :count).by(-1)
    end

    it "redirects to notifications index" do
      delete notification_path(notification)
      expect(response).to redirect_to(notifications_path)
    end
  end

  describe "PATCH /notifications/:id" do
    let(:notification) { create(:notification, user: user, actor: actor, read: false) }

    it "marks notification as read" do
      patch notification_path(notification)
      expect(notification.reload.read).to be true
    end

    it "redirects to notifications index" do
      patch notification_path(notification)
      expect(response).to redirect_to(notifications_path)
    end
  end
end
