class PagesController < ApplicationController
  def home
    if user_signed_in?
      all_invitations = Event.where(group_id: current_user.groups.ids).where.not(user_id: current_user.id).where('date >= ?', Date.today).order(date: :asc)
      @pending_events = all_invitations.select{ |event| event.votes.find_by(user: current_user).movie_event.present? }
      @invitations = all_invitations.select{ |event| event.votes.find_by(user: current_user).movie_event.nil? }
    end
    # @pending_events = []
    # @invitations = []
  end
end
