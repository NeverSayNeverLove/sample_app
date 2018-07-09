module ApplicationHelper
  def full_title page_title = ""
    base_title = t "static_pages.home.title"
    page_title ? page_title + " | " + base_title : base_title
  end
end
