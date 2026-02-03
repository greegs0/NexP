require 'rails_helper'

RSpec.describe "Conversations", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe "GET /conversations" do
    before do
      create(:message, sender: user, recipient: other_user, content: "Hello")
      create(:message, sender: other_user, recipient: user, content: "Hi")
    end

    it "returns success" do
      get conversations_path
      expect(response).to have_http_status(:success)
    end

    it "displays conversations" do
      get conversations_path
      expect(response.body).to include(other_user.display_name)
    end
  end

  describe "GET /conversations/:id" do
    before do
      create(:message, sender: user, recipient: other_user, content: "Message 1")
      create(:message, sender: other_user, recipient: user, content: "Message 2")
    end

    it "returns success" do
      get conversation_path(other_user)
      expect(response).to have_http_status(:success)
    end

    it "displays conversation messages" do
      get conversation_path(other_user)
      expect(response.body).to include("Message 1")
      expect(response.body).to include("Message 2")
    end

    it "marks received messages as read" do
      unread_message = create(:message, sender: other_user, recipient: user, read_at: nil)
      get conversation_path(other_user)
      expect(unread_message.reload.read_at).not_to be_nil
    end
  end

  describe "POST /conversations/:id/messages" do
    context "with valid params" do
      it "creates a new message" do
        expect {
          post conversation_messages_path(other_user), params: { message: { content: "New message" } }
        }.to change(Message, :count).by(1)
      end

      it "creates a direct message" do
        post conversation_messages_path(other_user), params: { message: { content: "New message" } }
        message = Message.last
        expect(message.sender).to eq(user)
        expect(message.recipient).to eq(other_user)
        expect(message.project_id).to be_nil
      end

      it "awards XP to sender" do
        initial_xp = user.experience_points
        post conversation_messages_path(other_user), params: { message: { content: "New message" } }
        expect(user.reload.experience_points).to eq(initial_xp + 3)
      end

      it "creates a notification for recipient" do
        expect {
          post conversation_messages_path(other_user), params: { message: { content: "New message" } }
        }.to change { Notification.where(user: other_user, action: 'message').count }.by(1)
      end
    end
  end
end
