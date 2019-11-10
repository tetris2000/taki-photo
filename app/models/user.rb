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
  
  attr_accessor :terms_of_register
  validates :terms_of_register, acceptance: true, allow_nil: false, on: :create
  
  mount_uploader :icon_photo, IconPhotoUploader
  
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  
  has_many :relationships, dependent: :destroy
  has_many :followings, through: :relationships, source: :follow
  has_many :reverces_of_relationships, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
  has_many :followers, through: :reverces_of_relationships, source: :user
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def dlt_comment(pst)
    post_comment = self.post_comments.find_or_create_by(post_id: pst.id)
    post_comment.destroy if post_comment
  end
end
