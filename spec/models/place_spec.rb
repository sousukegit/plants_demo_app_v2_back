require 'rails_helper'

RSpec.describe Place, type: :model do
  #各テスト時に初期データセット
  before do
    @place = Place.new(
      name: "そうすけテストガーデニング",
      google_place_id: "ChIJ0_aaaaaaaaaaaaaaaaa",
      latitude: "33.123456789",
      longitude: "132.123456789"
    )
  end

  #すべて値があれば有効な状態であること
  it "is valid with a name,google_place_id,latitude,longitude" do
    expect(@place).to be_valid
  end
  #名前がなければ無効な状態であること
  it "is invalid without a name" do
    @place.name = nil
    expect(@place).to be_invalid
  end
  #placeidがなければ無効な状態であること
  it "is invalid without a google_place_id" do
    @place.google_place_id = nil
    expect(@place).to be_invalid
  end

  #緯度がなければ無効な状態であること
  it "is invalid without a latitude" do
    @place.latitude = nil
    expect(@place).to be_invalid
  end
  #経度がなければ無効な状態であること
  it "is invalid without a longitude" do
    @place.longitude = nil
    expect(@place).to be_invalid
  end

  #緯度に数字以外の文字が入っていないこと
  it "is invalid with a string in latitude" do
    @place.latitude = "32.3aあ@#%"
    @place.valid?
    expect(@place.errors[:latitude]).to include("は数値で入力してください")
  end
  #経度に数字以外の文字が入っていないこと
  it "is invalid with a string or index in longitude" do
    @place.longitude = "132.3aあ@#%"
    @place.valid?
    expect(@place.errors[:longitude]).to include("は数値で入力してください")
  end
  #緯度が90以上だとエラーがでること
  it "is invalid  90 range for latitude" do
    @place.latitude = "132.42"
    @place.valid?
    expect(@place.errors[:latitude]).to include("は90以下の値にしてください")
  end
  #経度が180以上だとエラーがでること
  it "is invalid without the 180 range for longitude" do
    @place.longitude = "200.42"
    @place.valid?
    expect(@place.errors[:longitude]).to include("は180以下の値にしてください")
  end
  #同じgoogle_place_idが1つ以上存在しない状態であること
  it "is invalid for unique of google_place_id " do
    @place.google_place_id = "ChIJ0_TWrRHuTzURSfDvHGXBjoM"
    @place.valid?
    expect(@place.errors[:google_place_id]).to include("すでに同じが登録されています")
  end


  #pending "add some examples to (or delete) #{__FILE__}"
end
