class Admin::DashboardController < Admin::BaseController
  def index
    @points_count = Point.count
    @events_count = Event.count
    @pending_registrations_count = Registration.pending.count
  end
end
