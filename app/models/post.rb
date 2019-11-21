class Post < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :like_users, through: :favorites, source: :user

  
  validates :title, presence: true, length: { maximum: 50 }
  validates :photo, presence: true
  validates :explanation, presence: true, length: { maximum: 255 }
  validates :waterfall, presence: true, length: { maximum: 50 }
  validates :use_exif, inclusion: {in: [true, false]}
  
  mount_uploader :photo, PostPhotoUploader
  
  def save_exif
    binding.pry
    unless self.photo == nil
      require "exifr/jpeg"
      self.taken_at = EXIFR::JPEG.new(self.photo.file.file).date_time
      self.shutter_speed = EXIFR::JPEG.new(self.photo.file.file).exposure_time
      self.f_number = EXIFR::JPEG.new(self.photo.file.file).f_number
      self.iso = EXIFR::JPEG.new(self.photo.file.file).iso_speed_ratings
      self.focal_length = EXIFR::JPEG.new(self.photo.file.file).focal_length
      self.camera = EXIFR::JPEG.new(self.photo.file.file).model
    end
  end
end
