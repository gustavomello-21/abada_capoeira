class Admin::PointsController < Admin::BaseController
  before_action :set_point, only: [ :edit, :update, :destroy ]

  def index
    @points = Point.order(:city)
  end

  def new
    @point = Point.new
  end

  def create
    @point = Point.new(point_params)
    if @point.save
      redirect_to admin_points_path, notice: "Ponto cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @point.update(point_params)
      redirect_to admin_points_path, notice: "Ponto atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @point.destroy
    redirect_to admin_points_path, notice: "Ponto removido."
  end

  private

  def set_point
    @point = Point.find(params[:id])
  end

  def point_params
    params.require(:point).permit(
      :teacher_name, :phone, :street, :number, :complement, :neighborhood,
      :city, :state, :zip_code, :details, :photo
    )
  end
end
