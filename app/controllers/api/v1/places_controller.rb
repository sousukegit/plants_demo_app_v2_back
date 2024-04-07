class Api::V1::PlacesController < ApplicationController

    def index
        places = Place.includes(reviews:[:user])
        reviews = Review.includes(:place)
        avg_reviews = reviews.group(:place_id).select(
            "place_id,
            ROUND(AVG(rating)::numeric,2) as rating,
            ROUND(AVG(mania_point)::numeric,2) as mania_point,
            ROUND(AVG(price_point)::numeric,2) as price_point,
            ROUND(AVG(health_point)::numeric,2) as health_point"
            )
        places.each do |place|
            # avg_reviews.each do |avg|
            #     place[:avg_reviews] = avg.place_id == place.id ? avg : null
            # end
            place[:avg_reviews] = avg_reviews.find { |avg| avg.place_id == place.id }
        end
         #render json: place.as_json(include: :reviews)
        render json: places.as_json(include: [reviews: { include: :user}])
    end

    def show
        place = Place.includes(reviews:[:user]).find(params[:id])
        render json: place.as_json(include: [reviews: { include: :user ,methods: [:image_url]}])
    end

     # パラメータの許可設定
     def place_params
        puts(params)
        params.require(:places).permit(:id)
    end

end
