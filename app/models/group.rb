class Group < ApplicationRecord
  has_many :events
  has_many :members
  has_many :users, through: :members
  validates :name, presence: true
  has_one_attached :group_picture
end
