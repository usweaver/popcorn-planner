class MovieComment < ApplicationRecord
  belongs_to :user
  belongs_to :movie_event
end
