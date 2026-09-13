class Admin::RegistrationsController < Admin::BaseController
  PER_PAGE = 20

  before_action :set_event
  before_action :set_registration, only: [ :show, :approve, :reject ]

  def index
    scope = @event.registrations.includes(:user, registration_answers: :event_field).order(created_at: :desc)
    @page = [ params[:page].to_i, 1 ].max
    @total_pages = (scope.count / PER_PAGE.to_f).ceil
    @registrations = scope.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
  end

  def show
  end

  def approve
    @registration.update!(status: :approved, rejection_reason: nil)
    redirect_to admin_event_registration_path(@event, @registration), notice: "Inscrição aprovada."
  end

  def reject
    @registration.update!(status: :rejected, rejection_reason: params[:rejection_reason])
    redirect_to admin_event_registration_path(@event, @registration), notice: "Inscrição rejeitada."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_registration
    @registration = @event.registrations.find(params[:id])
  end
end
