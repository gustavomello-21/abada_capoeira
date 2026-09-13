class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.published.upcoming_first
  end

  def show
    @event = Event.published.find(params[:id])
    @registration = @event.registrations.find_by(user: current_user)
  end
end
