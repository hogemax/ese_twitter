class Citation < ApplicationRecord
  belongs_to :repost, class_name: "Micropost"
  belongs_to :source, class_name: "Micropost"
  validates :repost_id, presence: true
  validates :source_id, presence: true
end
