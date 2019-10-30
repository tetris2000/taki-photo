class Post < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture
  
  validates :title, presence: true, length: { maximum: 50 }
  validates :photo, presence: true
  validates :explanation, presence: true, length: { maximum: 255 }
  validates :waterfall, presence: true, length: { maximum: 50 }
  validates :use_exif, inclusion: {in: [true, false]}
  
  mount_uploader :photo, PostPhotoUploader
end
