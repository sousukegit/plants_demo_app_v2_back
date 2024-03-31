class Api::V1::ReviewsController < ApplicationController

    def index
        reviews = Review.includes([:place,:user])
        render json: reviews.as_json(include:  { place: {}, user: {} }), methods: [:image_url]
    end

    def show
        review = Review.includes([:place,:user]).find(params[:id])
        render json: review.as_json(include: { place: {}, user: {} },methods: [:image_url])
    end

    def create
        review = Review.new(review_params)
        # @review.images.attach(params[:images])
        if review.save
            render json: { message: 'created successfully' }, status: :created
        else
            msg = "create false review"
            render status: 401, json: { status: 401, error: msg }
        end
    end

    def update
        review = Review.find_by(params[:id])
        if review.update!(review_params)
            render json: {message: 'update successfully'}
        else
            msg = "update false review"
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
            images:[]
            )
    end

end
