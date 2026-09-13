class Admin::EventsController < Admin::BaseController
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def index
    @events = Event.order(created_at: :desc)
  end

  def show
  end

  def new
    @event = Event.new
    3.times { @event.event_fields.build }
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to admin_event_path(@event), notice: "Evento criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @event.event_fields.build if @event.event_fields.empty?
  end

  def update
    if @event.update(event_params)
      redirect_to admin_event_path(@event), notice: "Evento atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to admin_events_path, notice: "Evento removido."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :starts_at, :ends_at, :registration_deadline, :status,
      event_fields_attributes: [ :id, :label, :field_type, :required, :position, :options_text, :_destroy ]
    )
  end
end
