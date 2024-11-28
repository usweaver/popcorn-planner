class PagesController < ApplicationController
  def home
    if user_signed_in?
      all_invitations = Event.where(group_id: current_user.groups.ids).where.not(user_id: current_user.id)
      @pending_events = all_invitations.joins(movie_events: :votes).where('date >= ?', Date.today)
      @invitations = all_invitations.where.not(id: @pending_events.ids)
    end
    # @pending_events = []
    # @invitations = []
  end
end
