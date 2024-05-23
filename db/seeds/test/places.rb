count=0
5.times do |n|


    names = [
        "ファンガーデンMASAKI",
        "まあるいばなな",
        "GreenBase ASODA",
        "成瀬多肉(多肉植物・リメイク鉢・ピック販売店)",
        "GreenTerrace109" 
    ]
    google_place_ids = [
      "ChIJ0_TWrRHuTzURSfDvHGXBjoM", #ファンガーデンMASAKI
      "ChIJZbM7TMMrUDURUVsnQcLN2Q4", #まあるいばなな
      "ChIJcTORaPLvTzURxvfXH3VbvLo", #GreenBase ASODA
      "ChIJLxABYOvpTzURzvX365jGo_w", #成瀬多肉(多肉植物・リメイク鉢・ピック販売店)
      "ChIJy4K5Q4zvTzURYUO3kwmVfT0"  #GreenTerrace109
    ]
    #緯度
    latitude  = [
      33.7855738955378, 
      33.896966781165546, 
      33.82419874602843, 
      33.780042654686014, 
      33.82126865886753
    ]
    #経度
    longitude = [
      132.71488267475482,
      133.098793241029,
      132.76578908150182,
      132.85467629869734,
      132.77267248335426
    ]
    name = names[n]
    google_place_id = google_place_ids[n]
    longitude = longitude[n]
    latitude = latitude[n]

    #Idが存在しなけれなnew
    place = Place.find_or_initialize_by(google_place_id: google_place_id)
    
    #new_recordsで戻り値を確認
    if place.new_record?
        place.name = name
        place.google_place_id = google_place_id
        place.longitude = longitude
        place.latitude = latitude
        place.save!
    else      
      place.update!(
        name:  name,
        google_place_id: google_place_id,
        longitude: longitude,
        latitude: latitude
      )
    end
  end
  
  puts "place = #{Place.count}"
