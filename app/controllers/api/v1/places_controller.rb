class Api::V1::PlacesController < ApplicationController

    def index
        place = Place.includes(:reviews)
        render json: place.as_json(include: :reviews) 
    end
    
end
