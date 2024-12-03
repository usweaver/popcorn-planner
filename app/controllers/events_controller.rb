class EventsController < ApplicationController

  def index
    all_invitations = Event.where(group_id: current_user.groups.ids).distinct
    @pending_events = all_invitations.where.not(user_id: current_user.id).where('date >= ?', Date.today).order(date: :asc)
    @done_events = all_invitations.where('date < ?', Date.today).order(date: :desc)
    @my_events = Event.where(user_id: current_user.id).where('date >= ?', Date.today).order(date: :asc)
    # @pending_events = []
    # @done_events = []
  end

  def show
    @event = Event.find(params[:id])
    @movies = Movie.all
    @user = @event.user
    @users = User.all
    @markers = [{
      lat: @user.latitude,
      lng: @user.longitude,
      # marker_html:"<div class='custom-marker' style='background-color: red; width: 20px; height: 20px; border-radius: 50%;'></div>",
    }]

    @ordered_movies = @event.list_movies.map{|movie| {movie: movie, votes: get_votes(movie, @event)}}.sort_by{|hash| -hash[:votes]}
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(
      group_id: event_params["group_id"],
      date: event_params["date"],
      name: event_params["name"],
      start_time: event_params["start_time"]
    )
    @event.user = current_user
    # p event_params
    string_movies = params[:event][:movie_infos].split('#####')
    p string_movies
    string_movies.each do |movie_infos|
      movie = get_movie(movie_infos)

      MovieEvent.create(
        movie: movie,
        event: @event
      )
    end

    if @event.save
      redirect_to events_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:group_id, :date, :name, :start_time, :movie_infos)
  end

  def get_movie(string)
    movie_name = string.split('**')[0]
    movie_synopsis = string.split('**')[1]
    movie_poster = string.split('**')[2]

    if Movie.exists?(name: movie_name)
      return Movie.find_by(name: movie_name)
    else
      return Movie.create(
        name: movie_name,
        poster_url: movie_poster,
        synopsis: movie_synopsis
      )
    end
  end

  def get_votes(movie, event)
    movie.events.find_by(id: event.id).votes.where(movie_event_id: event.movie_events.find_by(movie_id: movie.id)).count
  end
end
