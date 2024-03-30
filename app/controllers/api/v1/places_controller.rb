class Api::V1::PlacesController < ApplicationController

    def index
        place = Place.includes(reviews:[:user])
         #render json: place.as_json(include: :reviews)
        render json: place.as_json(include: [reviews: { include: :user}])
    end

    def show
        place = Place.includes(:reviews).find(params[:id])
        render json: place.as_json(include: :reviews) 
    end

     # パラメータの許可設定
     def place_params
        puts(params)
        params.require(:places).permit(:id)
    end
    
end
