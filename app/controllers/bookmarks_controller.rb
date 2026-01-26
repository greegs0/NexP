class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bookmarkable, only: [:create]

  def index
    @bookmarks = current_user.bookmarks
                             .includes(:bookmarkable)
                             .order(created_at: :desc)
                             .page(params[:page]).per(20)
  end

  def create
    @bookmark = current_user.bookmarks.find_or_initialize_by(
      bookmarkable: @bookmarkable
    )

    if @bookmark.new_record?
      @bookmark.save
      redirect_back(fallback_location: root_path, notice: 'Ajouté aux favoris.')
    else
      # Remove bookmark si déjà existant
      @bookmark.destroy
      redirect_back(fallback_location: root_path, notice: 'Retiré des favoris.')
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])
    @bookmark.destroy
    redirect_to bookmarks_path, notice: 'Favori supprimé.'
  rescue ActiveRecord::RecordNotFound
    redirect_to bookmarks_path, alert: "Ce favori n'existe pas."
  end

  private

  def set_bookmarkable
    if params[:post_id]
      @bookmarkable = Post.find(params[:post_id])
    elsif params[:project_id]
      @bookmarkable = Project.find(params[:project_id])
    else
      redirect_back(fallback_location: root_path, alert: "Élément non trouvé.")
    end
  end
end
