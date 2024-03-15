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
    name = names[n]
    google_place_id = google_place_ids[n]    
   
    puts google_place_id

    #Idが存在しなけれなnew
    place = Place.find_or_initialize_by(google_place_id: google_place_id)
    
    #new_recordsで戻り値を確認
    if place.new_record?
        place.name = name
        place.google_place_id = google_place_id
        place.save!
    end
  end
  
  puts "place = #{Place.count}"