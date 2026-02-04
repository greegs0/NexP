class SitemapsController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def index
    @projects = Project.where(status: %w[open in_progress]).order(updated_at: :desc).limit(1000)
    @users = User.where(available: true).order(updated_at: :desc).limit(1000)

    respond_to do |format|
      format.xml { render layout: false }
    end
  end
end
