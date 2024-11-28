class Vote < ApplicationRecord
  belongs_to :movie_event
  belongs_to :user
  has_many :events, through: :movie_events
end
