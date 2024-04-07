class Api::V1::ReviewsController < ApplicationController

    #店舗のレビュー一覧
    def index
        reviews = Review.includes([:place,:user])
        render json: reviews.as_json(include:  { place: {}, user: {} }), methods: [:image_url]
    end

    #レビュー平均値
    # def average

    # end

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
