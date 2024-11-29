class EventsController < ApplicationController

  def index
    all_invitations = Event.where(group_id: current_user.groups.ids).distinct
    @pending_events = all_invitations.joins(movie_events: :votes).where('date >= ?', Date.today)
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
  end

  def create
  end
end
