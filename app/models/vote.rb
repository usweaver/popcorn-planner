class Vote < ApplicationRecord
  belongs_to :movie_event
  belongs_to :user
end
