require 'open-uri'
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
    @movie = Movie.find(params[:id])
    @events = @movie.events
  end

  def search
    url = "https://api.themoviedb.org/3/search/movie?query=#{params[:query]}&api_key=#{ENV['TMDB_API_KEY']}&language=fr-FR&page=1"

    response = URI.open(url).read
    json = JSON.parse(response)

    respond_to do |format|
      format.json {
        render json: { response: json }
      }
    end
  end
end
