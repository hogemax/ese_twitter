class Contact < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :age, numericality: { only_integer: true }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  #validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :content, presence: true, length: { maximum: 300 }
end
