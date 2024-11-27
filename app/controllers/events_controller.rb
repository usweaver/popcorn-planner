class EventsController < ApplicationController
  def index
    all_invitations = Event.where(group_id: current_user.groups.ids).where.not(user_id: current_user.id)
    @pending_events = all_invitations.joins(movie_events: :votes).where('date >= ?', Date.today)
    @done_events = all_invitations.joins(movie_events: :votes).where('date < ?', Date.today)
    # @pending_events = []
    # @done_events = []
  end

  def show
  end

  def new
  end

  def create
  end
end
