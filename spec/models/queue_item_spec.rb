require 'spec_helper'

describe QueueItem do
  it {should belong_to(:user)}
  it {should belong_to(:video)}
  it {should validate_numericality_of(:position).only_integer}

  describe "#video_title" do
    it "returns the title of the associcated video" do
      video = Fabricate(:video, title: "GoT")
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq("GoT")
    end
  end

  describe "#rating" do
    it "returns rating if review is present" do
      user = Fabricate(:user)
      video = Fabricate(:video, title: "GoT")
      review = Fabricate(:review, rating: 4, video: video, user: user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(4)
    end

    it "returns nil if review is not present" do
      user = Fabricate(:user)
      video = Fabricate(:video, title: "GoT")
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#rating=" do
    it "changes the review if the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it "clear the rating if the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end

    it "creates a review with rating if the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end

  describe "#category_name" do
    it "returns the category's name of the video" do
      user = Fabricate(:user)
      category = Fabricate(:category)
      video = Fabricate(:video)
      video.categories << category
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.category_name).to eq(category.name)
    end
  end
end