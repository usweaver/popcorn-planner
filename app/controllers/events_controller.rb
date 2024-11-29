class EventsController < ApplicationController
  def index
  end

  def show
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
