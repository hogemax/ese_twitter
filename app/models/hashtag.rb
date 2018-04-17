class Hashtag < ApplicationRecord
  has_and_belongs_to_many :microposts
  before_destroy {|hashtag| hashtag.microposts.clear}
  #validates :name, uniqueness: true
end
