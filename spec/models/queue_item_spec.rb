require 'spec_helper'

describe QueueItem do
  it {should belong_to(:user)}
  it {should belong_to(:video)}

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