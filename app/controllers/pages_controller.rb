class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  def home
    @invitations =
    @pending_events = current_user.events
  end
end
