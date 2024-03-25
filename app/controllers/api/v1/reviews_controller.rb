class Api::V1::ReviewsController < ApplicationController

    def index
        reviews = Review.includes(:place)
        render json: reviews.as_json(include: :place), methods: [:image_url]
    end

    def show
        review = Review.includes(:place).includes(:user).find(params[:id])
        render json: review.as_json(include: { place: {}, user: {} },methods: [:image_url])
    end

    def create
        @review = Review.new(review_params)
        if @review.save
            render json: { message: 'created successfully' }, status: :created ,methods: [:image_url]
        else
            msg = "create false review"
            render status: 401, json: { status: 401, error: msg }
        end
    end

    # パラメータの許可設定
    def review_params
        params.permit(
            :place_id, 
            :google_place_id,
            :rating,
            :comment,
            :price_point,
            :mania_point,
            :health_point,
            :user_id,
            :image
            )
    end

end
