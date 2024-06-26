class Api::V1::ReviewsController < ApplicationController

    #店舗のレビュー一覧
    def index
        reviews = Review.includes([:place,:user])
        render json: reviews.as_json(include:  { place: {}, user: {} }), methods: [:image_url]
    end

    #レビュー平均値
    def average
        reviews = Review.includes(:place)
        av_reviews = reviews.group(:place_id).select(
            "place_id,
            ROUND(AVG(rating)::numeric,2) as rating,
            ROUND(AVG(mania_point)::numeric,2) as mania_point,
            ROUND(AVG(price_point)::numeric,2) as price_point,
            ROUND(AVG(health_point)::numeric,2) as health_point"
            )
        #整数型なら小数点第一位を付ける
        av_reviews.each do |review|
          review.rating = review.rating.to_s + (review.rating.to_i == review.rating.to_f ? ".0" : "" )
          review.mania_point = review.mania_point.to_s + (review.mania_point.to_i == review.mania_point ? ".0" : "" )
          review.health_point = review.health_point.to_s + (review.health_point.to_i == review.health_point ? ".0" : "" )
          review.price_point = review.price_point.to_s + (review.price_point.to_i == review.price_point ? ".0" : "" )
        end

        render json: av_reviews.as_json(include: :place)
    end

    #詳細
    def show
        review = Review.includes([:place,:user]).find(params[:id])
        render json: review.as_json(include: { place: {}, user: {} },methods: [:image_url])
    end

    #レビュー投稿
    def create
        review = Review.new(review_params)
        #review.images.attach(params[:images])
        if review.save
            render json: { message: 'created successfully' }, status: :created
        else
            msg = "create false review"
            render status: 401, json: { status: 401, error: msg }
        end
    end

    #レビュー更新
    def update
        review = Review.find_by(id: params[:id])
        mix_images = params[:images]
        if(mix_images.present?)
            mix_images.map!{|mix_image| mix_image.is_a?(String) ? changeBlob(mix_image) : mix_image}
        end
        review.images = mix_images
        ActiveRecord::Base.transaction do
            if review.update!(review_params)
                render json: {message: 'update successfully'}
            else
                msg = "update false review"
                render status: 401, json: { status: 401, error: msg }
            end
        end
        
    end


    def destroy
        review = Review.find_by(id: params[:id])        
        if review.destroy
            render json: {message: 'delete successfully'}
        else
            msg = "delete false review"
            render status: 401, json: { status: 401, error: msg }
        end
      
    end

    private

    # パラメータの許可設定
    def review_params
        params.permit(
            :id,
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

    def changeBlob(mix_image)
        key = mix_image.split("/")[-2]
        blob = ActiveStorage::Blob.find_signed(key)
    end

end
