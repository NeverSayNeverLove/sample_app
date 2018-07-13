class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = current_user.microposts.sort_by_created_at.paginate page: params[:page],
      per_page: Settings.paginate.per_page
  end

  def help; end

  def about; end

  def contact; end
end
