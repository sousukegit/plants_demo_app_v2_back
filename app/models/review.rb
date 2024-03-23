class Review < ApplicationRecord
    include Rails.application.routes.url_helpers

    #1ユーザーに複数のレビュー
    belongs_to :user
    #1つの場所に複数のレビュー
    belongs_to :place
    #Active Storageで複数の画像を添付する
    has_one_attached :image

    def image_url
        # 紐づいている画像のURLを取得する
        image.attached? ? url_for(image) : nil
    end

end
