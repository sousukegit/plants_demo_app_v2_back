class Review < ApplicationRecord
    include Rails.application.routes.url_helpers

    #1ユーザー
    belongs_to :user
    #1つの場所に複数のレビュー
    belongs_to :place
    #Active Storageで複数の画像を添付する
    has_many_attached :images

    validate :restrict_one_review_per_user_per_place

    def image_url
        # 紐づいている画像のURLを取得する
        images.attached? ? images.map{|image| url_for(image)} : nil
    end

    validates :google_place_id, presence: true,
                    length:{maximum:100, allow_blank:true}
    validate :validate_google_place_id_existence

    validates :comment,
                    length:{maximum:2000, allow_blank:true}

    #評価は5段階評価
    validates :rating, presence: true,
                    numericality: {
                        greater_than_or_equal_to:1.0,
                        less_than_or_equal_to:5.0,
                    }

    validates :price_point, presence: true,
                    numericality: {
                        greater_than_or_equal_to:1.0,
                        less_than_or_equal_to:5.0,
                    }

    validates :mania_point, presence: true,
                    numericality: {
                        greater_than_or_equal_to:1.0,
                        less_than_or_equal_to:5.0,
                    }

    validates :health_point, presence: true,
                    numericality: {
                        greater_than_or_equal_to:1.0,
                        less_than_or_equal_to:5.0,
                    }

    #1か所につき、ユーザーは一回のレビューしかできない
    def restrict_one_review_per_user_per_place
        return false unless new_record?
        # メソッドの実装を記述する
        isReviewExist = Review.find_by(user_id: user_id, place_id: place_id).present?
        if isReviewExist
            errors.add(:base,"同じ場所につきレビューは一回までです")
        end
    end

    def validate_google_place_id_existence
        errors.add(:google_place_id,"存在しないGooglePlaceIDです") unless Place.exists?(google_place_id: google_place_id)
    end

end
