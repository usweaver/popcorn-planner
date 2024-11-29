class EventsController < ApplicationController

  def index
    all_invitations = Event.where(group_id: current_user.groups.ids).distinct
    @pending_events = all_invitations.left_outer_joins(movie_events: :votes).where('date >= ?', Date.today)
    @done_events = all_invitations.joins(movie_events: :votes).where('date < ?', Date.today)
    # @pending_events = []
    # @done_events = []
  end

  def show
    @event = Event.find(params[:id])
    # @movie = Movie.find(params[:movie_id])
    @movies = Movie.all
    @user = @event.user
    @users = User.all
    @markers = [{
      lat: @user.latitude,
      lng: @user.longitude,
      # marker_html:"<div class='custom-marker' style='background-color: red; width: 20px; height: 20px; border-radius: 50%;'></div>",
    }]
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
end
