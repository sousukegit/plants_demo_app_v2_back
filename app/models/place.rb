class Place < ApplicationRecord
    #1つの場所に対して複数のレビュー
    has_many :reviews 
end
