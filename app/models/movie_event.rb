class MovieEvent < ApplicationRecord
  belongs_to :event
  belongs_to :movie
  has_many :votes
  has_many :movie_comments
end
