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
  validates :use_exif, inclusion: { in: [true, false] }
  
  mount_uploader :photo, PostPhotoUploader
  
  def save_exif
    unless self.photo == nil
      require "exifr/jpeg"
      binding.pry
      self.taken_at = EXIFR::JPEG.new(self.photo.file.file).date_time
      self.shutter_speed = EXIFR::JPEG.new(self.photo.file.file).exposure_time.to_f
      self.f_number = EXIFR::JPEG.new(self.photo.file.file).f_number.to_f
      self.iso = EXIFR::JPEG.new(self.photo.file.file).iso_speed_ratings.to_i
      self.focal_length = EXIFR::JPEG.new(self.photo.file.file).focal_length.to_f
      self.camera = EXIFR::JPEG.new(self.photo.file.file).model
    end
  end
  
  scope :search_post, -> (search_params) do
    return if search_params.blank?
    
    prefecture_id_is(search_params[:prefecture_id])
    .waterfall_like(search_params[:waterfall])
    .shutter_speed_from(search_params[:shutter_speed_from])
    .shutter_speed_to(search_params[:shutter_speed_to])
    .f_number_from(search_params[:f_number_from])
    .f_number_to(search_params[:f_number_to])
    .focal_length_from(search_params[:focal_length_from])
    .focal_length_to(search_params[:focal_length_to])
    .camera_like(search_params[:camera])
    .exif_true
    # .taken_at_from(search_params[:taken_at_from])
    # .taken_at_to(search_params[:taken_at_to])
  end

  scope :prefecture_id_is, -> (prefecture_id) { where(prefecture_id: prefecture_id) if prefecture_id.present? }
  scope :waterfall_like, -> (waterfall) { where("waterfall LIKE ?", "%#{waterfall}%") if waterfall.present? }
  # scope :taken_at_from, -> (taken_at_from) { where("? <= taken_at", taken_at_from) if taken_at_from.present? }
  # scope :taken_at_to, -> (taken_at_to) { where("taken_at <= ?", taken_at_to) if taken_at_to.present? }
  scope :shutter_speed_from, -> (shutter_speed_from) { where("? <= shutter_speed", shutter_speed_from) if shutter_speed_from.present? }
  scope :shutter_speed_to, -> (shutter_speed_to) { where("shutter_speed <= ?", shutter_speed_to) if shutter_speed_to.present? }
  scope :f_number_from, -> (f_number_from) { where("? <= f_number", f_number_from) if f_number_from.present? }
  scope :f_number_to, -> (f_number_to) { where("f_number_to <= ?", f_number_to) if f_number_to.present? }
  scope :focal_length_from, -> (focal_length_from) { where("? <= focal_length", focal_length_from) if focal_length_from.present? }
  scope :focal_length_to, -> (focal_length_to) { where("f_number_to <= ?", f_number_to) if focal_length_to.present? }
  scope :camera_like, -> (camera) { where("camera LIKE ?", "%#{camera}%") if camera.present? }
  scope :exif_true, -> { where(use_exif: true) }
end
