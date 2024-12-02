class MovieEvent < ApplicationRecord
  belongs_to :event
  belongs_to :movie, optional: true
  has_many :movie_comments
  has_one :vote

  has_one :user, through: :vote
end
