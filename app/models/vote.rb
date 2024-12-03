class Vote < ApplicationRecord
  belongs_to :movie_event, optional: true
  belongs_to :user
  belongs_to :event

  # movie, fait référence au film choisi dans l'event en cours
  has_one :movie, -> { where movie_events: { selected_movie: true } }, through: :movie_event
end
