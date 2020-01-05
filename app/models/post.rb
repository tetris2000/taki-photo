class Post < ApplicationRecord
  belongs_to :user
  # バリデーションエラーの内容表記を変更したい＋表記順番を変えたいためoptional:trueにし、別途validationを設定
  belongs_to :prefecture, optional: true
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :like_users, through: :favorites, source: :user

  
  validates :photo, presence: { message: "を選択してください" }
  validates :title, presence: true, length: { maximum: 50 }
  validates :explanation, presence: true, length: { maximum: 255 }
  validates :waterfall, presence: true, length: { maximum: 50 }
  validates :prefecture_id, presence: { message: "を選択してください"}
  validates :use_exif, inclusion: { in: [true, false], message: "を使用するかどうか選択してください" }
  
  mount_uploader :photo, PostPhotoUploader
  
  def save_exif
    require "exifr/jpeg"
    self.taken_at = EXIFR::JPEG.new(self.photo.file.file).date_time
    self.taken_at_year = EXIFR::JPEG.new(self.photo.file.file).date_time.strftime("%Y").to_i
    self.taken_at_month = EXIFR::JPEG.new(self.photo.file.file).date_time.strftime("%m").to_i
    self.shutter_speed = EXIFR::JPEG.new(self.photo.file.file).exposure_time.to_f
    self.f_number = EXIFR::JPEG.new(self.photo.file.file).f_number.to_f
    self.iso = EXIFR::JPEG.new(self.photo.file.file).iso_speed_ratings.to_i
    self.focal_length = EXIFR::JPEG.new(self.photo.file.file).focal_length.to_f
    self.camera = EXIFR::JPEG.new(self.photo.file.file).model
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
    .taken_at(search_params[:taken_at_year_from], search_params[:taken_at_month_from], search_params[:taken_at_year_to], search_params[:taken_at_month_to])
  end

  # 検索条件に0を許可するとExifを取得できなかった写真も出てしまう（DBの数値カラムには0で登録されている）
  scope :prefecture_id_is, -> (prefecture_id) { where(prefecture_id: prefecture_id) if prefecture_id.present? }
  scope :waterfall_like, -> (waterfall) { where("waterfall LIKE ?", "%#{waterfall}%") if waterfall.present? }
  # 分数入力を小数に変換した上で検索かけるためto_r->to_f
  scope :shutter_speed_from, -> (shutter_speed_from) { where("0 < shutter_speed").where("? <= shutter_speed", shutter_speed_from.to_r.to_f).exif_true if shutter_speed_from.present? }
  scope :shutter_speed_to, -> (shutter_speed_to) { where("0 < shutter_speed").where("shutter_speed <= ?", shutter_speed_to.to_r.to_f).exif_true if shutter_speed_to.present? }
  scope :f_number_from, -> (f_number_from) { where("0 < f_number").where("? <= f_number", f_number_from).exif_true if f_number_from.present? }
  scope :f_number_to, -> (f_number_to) { where("0 < f_number").where("f_number <= ?", f_number_to).exif_true if f_number_to.present? }
  scope :focal_length_from, -> (focal_length_from) { where("0 < focal_length").where("? <= focal_length", focal_length_from).exif_true if focal_length_from.present? }
  scope :focal_length_to, -> (focal_length_to) { where("0 < focal_length").where("focal_length <= ?", focal_length_to).exif_true if focal_length_to.present? }
  scope :camera_like, -> (camera) { where("camera LIKE ?", "%#{camera}%").exif_true if camera.present? }
  
  # 撮影日検索は年のみ/月のみ/年月両方で場合分け
  scope :taken_at, -> (taken_at_year_from, taken_at_month_from, taken_at_year_to, taken_at_month_to) do
    if taken_at_year_from.present? && taken_at_month_from.present? && taken_at_year_to.present? && taken_at_month_to.present?
      taken_at_from(taken_at_year_from, taken_at_month_from)
      .taken_at_to(taken_at_year_to, taken_at_month_to)
    elsif taken_at_year_from.present? && taken_at_month_from.present?
      taken_at_from(taken_at_year_from, taken_at_month_from)
      .taken_at_year_to(taken_at_year_to)
    elsif taken_at_year_to.present? && taken_at_month_to.present?
      taken_at_to(taken_at_year_to, taken_at_month_to)
      .taken_at_year_from(taken_at_year_from)
    elsif taken_at_year_from.present? || taken_at_year_to.present?
      taken_at_year_from(taken_at_year_from)
      .taken_at_year_to(taken_at_year_to)
    else
      taken_at_month_from(taken_at_month_from)
      .taken_at_month_to(taken_at_month_to)
    end
  end
  scope :taken_at_from, -> (taken_at_year_from, taken_at_month_from) { where("? <= taken_at", DateTime.parse("#{taken_at_year_from}/#{taken_at_month_from}")).exif_true }
  scope :taken_at_to, -> (taken_at_year_to, taken_at_month_to) { where("taken_at <= ?", DateTime.parse("#{taken_at_year_to}/#{taken_at_month_to}")).exif_true }
  scope :taken_at_month_from, -> (taken_at_month_from) { where("? <= taken_at_month", taken_at_month_from).exif_true if taken_at_month_from.present? }
  scope :taken_at_month_to, -> (taken_at_month_to) { where("0 < taken_at_month").where("taken_at_month <= ?", taken_at_month_to).exif_true if taken_at_month_to.present? }
  scope :taken_at_year_from, -> (taken_at_year_from) { where("? <= taken_at_year", taken_at_year_from).exif_true if taken_at_year_from.present? }
  scope :taken_at_year_to, -> (taken_at_year_to) { where("0 < taken_at_year").where("taken_at_year <= ?", taken_at_year_to).exif_true if taken_at_year_to.present? }
  
  # 露光時間別投稿一覧用
  scope :slow_shutter, -> { where("0.5 <= shutter_speed").exif_true }
  scope :fast_shutter, -> { where("0 < shutter_speed").where("shutter_speed <= 0.002").exif_true }
  
  # 季節別投稿一覧用
  scope :spring, -> { where(taken_at_month: 3..5).exif_true }
  scope :summer, -> { where(taken_at_month: 6..8).exif_true }
  scope :autumn, -> { where(taken_at_month: 9..11).exif_true }
  scope :winter, -> { where(taken_at_month: [1,2,12]).exif_true }
  
  # Exif情報を使用する投稿のみを検索対象とする
  scope :exif_true, -> { where(use_exif: true) }
end