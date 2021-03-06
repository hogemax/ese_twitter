class Micropost < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_and_belongs_to_many :hashtags

  default_scope -> { order('created_at DESC') }
  scope :search_by_id, ->(post_id) { find_by(id: post_id) }

  validates :content, presence: true, length: { maximum: 540 }
  validates :user_id, presence: true

  has_many :likes, dependent: :destroy
  has_many :iine_users, through: :likes, source: :user
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

  # 未使用かも↓
  def like_user(user_id)
    likes.find_by(user_id: user_id)
  end

  def repost!(other_micropost)
    citations.create!(repost_id: other_micropost.id)
  end


  ##--- いいね機能  ---##

  # 現在のユーザーがいいねしてたらtrueを返す
  def iine?(user)
    iine_users.include?(user)
  end

  # 投稿にいいねをつける
  def iine(user)
    likes.create(user_id: user.id)
  end
  # 投稿のいいねを解除（ネーミングイケてない）
  def uniine(user)
    likes.find_by(user_id: user.id).destroy
  end

end
