class Review < ApplicationRecord
    include Rails.application.routes.url_helpers

    #1ユーザー
    belongs_to :user
    #1つの場所に複数のレビュー
    belongs_to :place
    #Active Storageで複数の画像を添付する
    has_many_attached :images

    def image_url
        # 紐づいている画像のURLを取得する
        images.attached? ? images.map{|image| url_for(image)} : nil
    end

end
