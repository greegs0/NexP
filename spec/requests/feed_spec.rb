require 'rails_helper'

RSpec.describe "Feed", type: :request do
  let(:user) { create(:user) }
  let(:followed_user) { create(:user) }

  before do
    sign_in user
    user.follow(followed_user)
  end

  describe "GET /feed" do
    before do
      create(:post, user: user, content: "My post")
      create(:post, user: followed_user, content: "Followed user post")
      create(:post, user: create(:user), content: "Other user post")
    end

    it "returns success" do
      get feed_path
      expect(response).to have_http_status(:success)
    end

    it "displays posts from current user" do
      get feed_path
      expect(response.body).to include("My post")
    end

    it "displays posts from followed users" do
      get feed_path
      expect(response.body).to include("Followed user post")
    end

    it "does not display posts from non-followed users" do
      get feed_path
      expect(response.body).not_to include("Other user post")
    end
  end
end
