class Micropost < ApplicationRecord
  belongs_to :user
  scope sort_by_created_at, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micro.content}
  validate  :picture_size

  private

  def picture_size
    return if picture.size <= Settings.pic.sizemb.megabytes
    errors.add :picture, t("model.micro.picsize")
  end
end
