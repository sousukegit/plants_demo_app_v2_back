require 'rails_helper'

RSpec.describe Review, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
   #各テスト時に初期データセット
   before do
    @review = Review.new(
      google_place_id: "ChIJ0_TWrRHuTzURSfDvHGXBjoM",
      comment: "User1レビューテスト",
      rating:4.0,
      price_point: 4.0,
      mania_point: 4.0,
      health_point: 4.0,
      place_id: 5,
      user_id: 9
    )
  end

 #すべて値があれば有効な状態であること
 it "is valid with all" do
  expect(@review).to be_valid
 end

  #各要素にデータが入っていない場合、エラーがでるか
  it "is valid with a without a google_place_id" do
    @review.google_place_id = nil
    expect(@review).to be_invalid
  end

  it "is invalid without a price_point" do
    @review.price_point = nil
    expect(@review).to be_invalid
  end

  it "is invalid without a mania_point" do
    @review.mania_point = nil
    expect(@review).to be_invalid
  end

  it "is invalid without a health_point" do
    @review.health_point = nil
    expect(@review).to be_invalid
  end

  it "is invalid without a rating" do
    @review.rating = nil
    expect(@review).to be_invalid
  end

  it "is invalid without a place_id" do
    @review.place_id = nil
    expect(@review).to be_invalid
  end

  it "is invalid without a user_id" do
    @review.user_id = nil
    expect(@review).to be_invalid
  end


  # 存在しない値をバリデートできているか
  it "is invalid not exist google_place_id in Places" do
    @review.google_place_id = "ChIJ0_aaaaaaaaaaaaaaaaa"
    @review.valid?
    expect(@review.errors[:google_place_id]).to include("存在しないGooglePlaceIDです")
  end

  it "is invalid not exist place_id in Places" do
    @review.place_id = 999
    expect(@review).to be_invalid
  end

  it "is invalid not exist user_id in Users" do
    @review.user_id = 999
    expect(@review).to be_invalid
  end

  #評価が範囲内の数であるか
  it "is invalid without the 5.0 range for rating" do
    @review.rating = "6.0"
    @review.valid?
    expect(@review.errors[:rating]).to include("は5.0以下の値にしてください")
  end

  it "is invalid without the 1.0 range for rating" do
    @review.rating = "0.5"
    @review.valid?
    expect(@review.errors[:rating]).to include("は1.0以上の値にしてください")
  end

  it "is invalid without the 5.0 range for price_point" do
    @review.price_point = "6.0"
    @review.valid?
    expect(@review.errors[:price_point]).to include("は5.0以下の値にしてください")
  end

  it "is invalid without the 1.0 range for price_point" do
    @review.price_point = "0.5"
    @review.valid?
    expect(@review.errors[:price_point]).to include("は1.0以上の値にしてください")
  end

  it "is invalid without the 5.0 range for mania_point" do
    @review.mania_point = "6.0"
    @review.valid?
    expect(@review.errors[:mania_point]).to include("は5.0以下の値にしてください")
  end

  it "is invalid without the 1.0 range for mania_point" do
    @review.mania_point = "0.5"
    @review.valid?
    expect(@review.errors[:mania_point]).to include("は1.0以上の値にしてください")
  end

  it "is invalid without the 5.0 range for health_point" do
    @review.rating = "6.0"
    @review.valid?
    expect(@review.errors[:rating]).to include("は5.0以下の値にしてください")
  end

  it "is invalid without the 1.0 range for health_point" do
    @review.rating = "0.5"
    @review.valid?
    expect(@review.errors[:rating]).to include("は1.0以上の値にしてください")
  end
  #画像URLのホストは環境変数のホストになっているか

  #添付されている画像ファイルは20000以下か

  #店舗1件に対するレビューは、1ユーザーにつき1回になっているか
  it "is invalid for one review per user per place" do
    @review.place_id = 1
    @review.user_id = 9
    @review.valid?
    expect(@review.errors[:base]).to include("同じ場所につきレビューは一回までです")
  end

end
