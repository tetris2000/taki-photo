class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { in: 8..255 },on: :create,
                    format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i }
  validates :password, presence: true, length: { in: 8..255 }, allow_nil: true, on: :update,
                    format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i }
  has_secure_password
  validates :introduction, length: { maximum: 255 }
  
  mount_uploader :icon_photo, IconPhotoUploader
  
  has_many :posts
end
