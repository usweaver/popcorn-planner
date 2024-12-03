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
    year = params[:event][:date].split("-")[0]
    month = params[:event][:date].split("-")[1]
    day = params[:event][:date].split("-")[2]
    hour = params[:event][:start_time].split(":")[0]
    minute = params[:event][:start_time].split(":")[1]

    @event = Event.new(
      group_id: event_params["group_id"],
      date: Time.new(year, month, day, hour, minute, 0),
      name: event_params["name"],
    )
    @event.user = current_user
    string_movies = params[:event][:movie_infos].split('---')
    string_movies.each do |movie_infos|
      movie = get_movie(movie_infos)
      MovieEvent.create(movie: movie, event: @event)
    end

    if @event.save
      @event.launch
      redirect_to events_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_recap
    name = params[:name]
    group = Group.find(params[:group])
    date = params[:date]
    time = params[:time].to_time.strftime("%H:%M")
    imdb_movie = params[:movies_infos].split("---").map { |movie| movie.split("**")[2] }

    render json: {
      recap_html: render_to_string(partial: "recap", locals: { name: name, group: group, date: date, time: time, movie_posters: imdb_movie }, formats: :html)
    }
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
