class MoviesController < ApplicationController
  def index
    # Récupérer les IDs des groupes auxquels appartient l'utilisateur
    user_group_ids = current_user.groups.ids

    # Récupérer les films répondant aux critères
    @movies = Movie.joins(movie_events: :event)
                       .where(movie_events: { selected_movie: true })
                       .where('events.user_id = ? OR events.group_id IN (?)', current_user.id, user_group_ids)
                       .where('events.date < ?', Date.today)
  end

  def show
  end
end
