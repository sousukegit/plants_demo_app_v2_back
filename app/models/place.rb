class Place < ApplicationRecord
    #1つの場所に対して複数のレビュー
    has_many :reviews 
    #平均値を入れるために追加
    attribute :avg_reviews
end
