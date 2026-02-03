# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:project) { create(:project, owner: user) }

  describe "GET /projects/:project_id/messages" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get project_messages_path(project)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as project owner" do
      before { sign_in user }

      it "returns http success" do
        get project_messages_path(project)
        expect(response).to have_http_status(:success)
      end

      it "displays project messages" do
        message = create(:message, :project_message, project: project, sender: user, content: 'Hello team!')

        get project_messages_path(project)
        expect(response.body).to include('Hello team!')
      end
    end

    context "when authenticated as project member" do
      before do
        create(:team, user: other_user, project: project, status: 'accepted')
        sign_in other_user
      end

      it "returns http success" do
        get project_messages_path(project)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated but not a member" do
      before { sign_in other_user }

      it "redirects with alert" do
        get project_messages_path(project)
        expect(response).to redirect_to(project)
      end
    end
  end

  describe "POST /projects/:project_id/messages" do
    context "when authenticated as project owner" do
      before { sign_in user }

      it "creates a new message" do
        expect {
          post project_messages_path(project), params: { message: { content: 'New message' } }
        }.to change(Message, :count).by(1)
      end

      it "sets the sender to current user" do
        post project_messages_path(project), params: { message: { content: 'New message' } }
        expect(Message.last.sender).to eq(user)
      end

      it "sanitizes HTML content" do
        post project_messages_path(project), params: { message: { content: '<script>alert("xss")</script>Hello' } }
        expect(Message.last.content).not_to include('<script>')
        expect(Message.last.content).to include('Hello')
      end

      it "does not create message with blank content" do
        expect {
          post project_messages_path(project), params: { message: { content: '' } }
        }.not_to change(Message, :count)
      end

      it "does not create message exceeding max length" do
        long_content = 'a' * 1001

        expect {
          post project_messages_path(project), params: { message: { content: long_content } }
        }.not_to change(Message, :count)
      end
    end

    context "when authenticated as project member" do
      before do
        create(:team, user: other_user, project: project, status: 'accepted')
        sign_in other_user
      end

      it "creates a new message" do
        expect {
          post project_messages_path(project), params: { message: { content: 'Member message' } }
        }.to change(Message, :count).by(1)
      end
    end

    context "when authenticated but not a member" do
      before { sign_in other_user }

      it "does not create a message" do
        expect {
          post project_messages_path(project), params: { message: { content: 'Unauthorized' } }
        }.not_to change(Message, :count)
      end
    end
  end
end
