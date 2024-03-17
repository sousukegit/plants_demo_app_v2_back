class Api::V1::ReviewsController < ApplicationController

    def index
        reviews = Review.includes(:place)
        render json: reviews.as_json(include: :place)
    end

    def create
        @review = Review.new(review_params)
        if @review.save
            render json: { message: 'created successfully' }, status: :created
        else
            msg = "create false review"
            render status: 401, json: { status: 400, error: msg }
        end
    end

    # パラメータの許可設定
    def review_params
        params.require(:review).permit(
            :place_id, 
            :google_place_id, 
            :comment,
            :price_point,
            :mania_point,
            :health_point,
            :user_id)
    end

end
