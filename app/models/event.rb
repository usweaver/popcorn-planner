class Event < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :movie_events, dependent: :destroy
  has_many :movies, through: :movie_events
  validates :date, :name, presence: true
end
