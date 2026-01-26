require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe "GET /posts" do
    it "returns success" do
      get posts_path
      expect(response).to have_http_status(:success)
    end

    it "displays posts" do
      post = create(:post, user: user)
      get posts_path
      expect(response.body).to include(post.content)
    end
  end

  describe "GET /posts/:id" do
    let(:post) { create(:post, user: user) }

    it "returns success" do
      get post_path(post)
      expect(response).to have_http_status(:success)
    end

    it "displays post content" do
      get post_path(post)
      expect(response.body).to include(post.content)
    end
  end

  describe "GET /posts/new" do
    it "returns success" do
      get new_post_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /posts" do
    context "with valid params" do
      it "creates a new post" do
        expect {
          post posts_path, params: { post: { content: "New post content" } }
        }.to change(Post, :count).by(1)
      end

      it "awards XP to user" do
        initial_xp = user.experience_points
        post posts_path, params: { post: { content: "New post content" } }
        expect(user.reload.experience_points).to eq(initial_xp + 10)
      end

      it "redirects to posts index" do
        post posts_path, params: { post: { content: "New post content" } }
        expect(response).to redirect_to(posts_path)
      end
    end

    context "with invalid params" do
      it "does not create a post" do
        expect {
          post posts_path, params: { post: { content: "" } }
        }.not_to change(Post, :count)
      end

      it "renders new template" do
        post posts_path, params: { post: { content: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /posts/:id/edit" do
    context "as post owner" do
      let(:post) { create(:post, user: user) }

      it "returns success" do
        get edit_post_path(post)
        expect(response).to have_http_status(:success)
      end
    end

    context "as non-owner" do
      let(:post) { create(:post, user: other_user) }

      it "redirects with alert" do
        get edit_post_path(post)
        expect(response).to redirect_to(post_path(post))
        follow_redirect!
        expect(response.body).to include("Vous n'êtes pas autorisé")
      end
    end
  end

  describe "PATCH /posts/:id" do
    let(:post) { create(:post, user: user) }

    context "as post owner with valid params" do
      it "updates the post" do
        patch post_path(post), params: { post: { content: "Updated content" } }
        expect(post.reload.content).to eq("Updated content")
      end

      it "redirects to post" do
        patch post_path(post), params: { post: { content: "Updated content" } }
        expect(response).to redirect_to(post_path(post))
      end
    end

    context "as non-owner" do
      let(:post) { create(:post, user: other_user) }

      it "does not update the post" do
        original_content = post.content
        patch post_path(post), params: { post: { content: "Updated content" } }
        expect(post.reload.content).to eq(original_content)
      end
    end
  end

  describe "DELETE /posts/:id" do
    let!(:post) { create(:post, user: user) }

    context "as post owner" do
      it "destroys the post" do
        expect {
          delete post_path(post)
        }.to change(Post, :count).by(-1)
      end

      it "redirects to posts index" do
        delete post_path(post)
        expect(response).to redirect_to(posts_path)
      end
    end

    context "as non-owner" do
      let!(:post) { create(:post, user: other_user) }

      it "does not destroy the post" do
        expect {
          delete post_path(post)
        }.not_to change(Post, :count)
      end
    end
  end
end
