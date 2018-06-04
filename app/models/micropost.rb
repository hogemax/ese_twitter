class Micropost < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 540 }
  validates :user_id, presence: true

  has_and_belongs_to_many :hashtags
  has_many :likes, dependent: :destroy

  has_many :citations, foreign_key: "repost_id", dependent: :destroy
  has_many :reposted_microposts, through: :citations, source: :repost


  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end

  def self.search(search)
    search ? where(['content LIKE ?', "%#{search}%"]) : all
  end

  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end

  def repost!(other_micropost)
    citations.create!(repost_id: other_micropost.id)
  end
end
