class MovieComment < ApplicationRecord
  belongs_to :user
  belongs_to :movie_event
  validates :comment, :rating, presence: true
end
