count=0

10.times do |n|

    google_place_ids = [
      "ChIJ0_TWrRHuTzURSfDvHGXBjoM", #ファンガーデンMASAKI
      "ChIJZbM7TMMrUDURUVsnQcLN2Q4", #まあるいばなな
      "ChIJcTORaPLvTzURxvfXH3VbvLo", #GreenBase ASODA
      "ChIJLxABYOvpTzURzvX365jGo_w", #成瀬多肉(多肉植物・リメイク鉢・ピック販売店)
      "ChIJy4K5Q4zvTzURYUO3kwmVfT0"  #GreenTerrace109
    ]
    google_place_id = google_place_ids[count]

    place_id = Place.find_by(google_place_id: google_place_id).id
    place_name = Place.find_by(google_place_id: google_place_id).name
    
    # 3 5 7 9で一カウントアップ
    if n.odd? && n!=1
      count += 1
    end      
    comment = "#{place_name}は大変すばらしい"
    price_point = rand(1..5)
    mania_point = rand(1..5)
    health_point = rand(1..5)
    rating = rand(1..5)
    user_id = n+1
    puts(user_id)
    #Idが存在しなけれなnew
    review = Review.find_or_initialize_by(id: n)
    
    #new_recordsで戻り値を確認
    if review.new_record?
      review.place_id = place_id
      review.google_place_id = google_place_id
      review.comment = comment
      review.price_point = price_point
      review.mania_point = mania_point
      review.health_point = health_point
      review.rating = rating
      review.user_id = user_id
      review.save!
    end
  end
  
  puts "reviews = #{Review.count}"