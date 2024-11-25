class Movie < ApplicationRecord
  has_many :movie_comments, through: :movie_events
  has_many :events, through: :movie_events
end
