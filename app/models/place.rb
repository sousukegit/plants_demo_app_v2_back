class Place < ApplicationRecord
    #1つの場所に対して複数のレビュー
    has_many :reviews 
    #平均値を入れるために追加
    attribute :avg_reviews
    validate :check_unique_google_place_id
    

    validates :name, presence: true,
                    length:{maximum:100, allow_blank:true}

    validates :google_place_id, presence: true,
                    length:{maximum:100, allow_blank:true}              


    validates :latitude, presence: true,
                    numericality: {
                        greater_than_or_equal_to:-90,
                        less_than_or_equal_to:90,
                    },
                    length:{maximum:100, allow_blank:true}

    validates :longitude, presence: true,
                    numericality: {
                        greater_than_or_equal_to:-180,
                        less_than_or_equal_to:180,
                    },
                    length:{maximum:100, allow_blank:true}

    
    def check_unique_google_place_id
        return false unless new_record?
        place = Place.all.present?
        if Place.find_by(google_place_id: google_place_id).present?
            errors.add(:google_place_id,"すでに同じが登録されています")
        end
    end

    # def check_unique_location
    #     return false unless new_record?
    #     uniqueLatitude = Place.find_by(latitude: latitude).present?
    #     uniqueLongitude = Place.find_by(longitude: longitude).present?
    #     if uniqueLongitude && uniqueLatitude
    #         errors.add(:latitude,"すでに同じが登録されています")
    #         errors.add(:longitude,"すでに同じが登録されています")

    #     end
    # end

end
