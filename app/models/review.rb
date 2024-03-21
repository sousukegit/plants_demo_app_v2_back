class Review < ApplicationRecord
    #1ユーザーに複数のレビュー
    belongs_to :user
    #1つの場所に複数のレビュー
    belongs_to :place

end
