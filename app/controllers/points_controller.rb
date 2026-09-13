class PointsController < ApplicationController
  def index
    @points = if params[:lat].present? && params[:lng].present?
      Point.near_ordered(params[:lat].to_f, params[:lng].to_f)
    else
      Point.geocoded.order(:city)
    end

    respond_to do |format|
      format.html
      format.json { render json: @points.map { |point| point_json(point) } }
    end
  end

  def show
    @point = Point.find(params[:id])
  end

  private

  def point_json(point)
    {
      id: point.id,
      teacher_name: point.teacher_name,
      phone: point.phone,
      city: point.city,
      state: point.state,
      address: point.full_street_address,
      details: point.details,
      latitude: point.latitude,
      longitude: point.longitude,
      photo_url: point.photo.attached? ? url_for(point.photo) : nil,
      show_url: point_path(point)
    }
  end
end
