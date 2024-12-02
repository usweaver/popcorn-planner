class Vote < ApplicationRecord
  belongs_to :movie_event
  belongs_to :user

  # event, fait référence à l'event en cours
  has_one :event, -> { where movie_events: { selected_movie: true } }, through: :movie_event
  # movie, fait référence au film choisi dans l'event en cours
  has_one :movie, -> { where movie_events: { selected_movie: true } }, through: :movie_event
end
