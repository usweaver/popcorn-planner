class Event < ApplicationRecord
  # User => Créateur du group
  belongs_to :user
  belongs_to :group
  has_many :members, through: :group
  has_many :votes, dependent: :destroy

  # guests => Ce sont les users qui sont invité le créateur n'est pas compris !
  has_many :guests, through: :members, source: :user

  has_many :movie_events, dependent: :destroy

  # list_movies => Liste de tout les films proposés
  has_many :list_movies, through: :movie_events, source: :movie

  # selected_movies => Liste des films séléctionné
  # utiliser la méthode selected_movie pour avoir une instance du film
  has_many :selected_movies, -> { where movie_events: { selected_movie: true } }, through: :movie_events, source: :movie

  has_many :votes

  validates :date, :name, presence: true

  GROUPES = Group.all.pluck(:name, :id)

  # Démarrer l'evennement
  # 1. Créer pour chaque utilisateur une instance de vote et de movie event qui lui appartient
  def launch
    Vote.create(
      user: user,
      event: self
    )
    guests.each do |gest|
      Vote.create(
        user: gest,
        event: self
      )
    end
  end

  def get_movie_event_by_user(user)
    votes.find_by(user: user).movie_event
  end
end
