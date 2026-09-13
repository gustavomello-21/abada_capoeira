class GeocodeController < ApplicationController
  def search
    query = params[:q].to_s.strip

    if query.blank?
      render json: { error: "empty_query" }, status: :unprocessable_entity
      return
    end

    result = Rails.cache.fetch("geocode:#{query.downcase}", expires_in: 1.day) do
      match = Geocoder.search(query).first
      match ? { lat: match.latitude, lng: match.longitude } : nil
    end

    if result
      render json: result
    else
      render json: { error: "not_found" }, status: :unprocessable_entity
    end
  end
end
