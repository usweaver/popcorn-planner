class EventsController < ApplicationController

  def index
  end

  def show
    @event = Event.find(params[:id])
    # @movie = Movie.find(params[:movie_id])
    @movies = Movie.all
    @user = @event.user
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
