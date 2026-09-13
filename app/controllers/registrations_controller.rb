class RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def new
    redirect_to event_path(@event), alert: "Você já está inscrito neste evento." and return if already_registered?

    @registration = @event.registrations.new
    @event.event_fields.each { |field| @registration.registration_answers.build(event_field: field) }
  end

  def create
    redirect_to event_path(@event), alert: "Você já está inscrito neste evento." and return if already_registered?

    @registration = @event.registrations.new(registration_params)
    @registration.user = current_user

    if @registration.save
      redirect_to event_path(@event), notice: "Inscrição enviada! Aguarde a aprovação do admin."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.published.find(params[:event_id])
  end

  def already_registered?
    @event.registrations.exists?(user: current_user)
  end

  def registration_params
    params.require(:registration).permit(
      :payment_proof,
      registration_answers_attributes: [ :event_field_id, :value ]
    )
  end
end
