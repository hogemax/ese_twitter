class Micropost < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 540 }
  validates :user_id, presence: true

  has_and_belongs_to_many :hashtags


  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  def self.search(search)
    search ? where(['content LIKE ?', "%#{search}%"]) : all
  end
end
