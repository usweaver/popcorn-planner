class MovieEvent < ApplicationRecord
  belongs_to :event
  belongs_to :movie, optional: true
  has_many :movie_comments
  has_one :vote, dependent: :destroy

  has_one :user, through: :vote
end
