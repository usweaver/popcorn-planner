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

  def vote
    @event = Event.find(params[:event_id])
    movie_event = @event.movie_events.find_by(movie: params[:id])
    vote = @event.votes.find_by(user: current_user)
    vote.movie_event = movie_event
    vote.save!

    # movie_events = event.movie_events
    # movie_events.each do |movie_event|
    #   movie_event.selected_movie = false
    #   movie_event.save!
    # end
    # votes = event.votes
    # selected_movie_event_id = votes.reject{|vote| vote.movie_event.nil? }.map(&:movie_event_id).tally.max_by{|_element, count| count}.first
    # selected_movie_event = Movie_event.find(selected_movie_event_id)
    # selected_movie_event.selected_movie = true
    # selected_movie_event.save!
    @movie = Movie.find(params[:id])
    flash[:notice] = "Votre vote pour #{@movie.name} est bien pris en compte."
    redirect_to event_path(@event)
  end
end
