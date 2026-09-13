class HomeController < ApplicationController
  def index
    @events = Event.published.upcoming_first.limit(3)
  end
end
