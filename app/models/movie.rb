class Movie < ApplicationRecord
  has_many :movie_events, dependent: :destroy
  has_many :movie_comments, through: :movie_events
  has_many :events, through: :movie_events
end
