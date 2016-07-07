require 'spec_helper'

describe Category do
  it { should have_many(:videos)}

  describe "#recent_videos" do
    it "returns the videos in the reverse order by created_at" do
      action = Category.create(name: "action")

      bb = Video.create(title:"Breaking bed", description: "Good")
      wd = Video.create(title: "The walking dead", description: "Good good")
      action.videos << bb
      action.videos << wd

      expect(action.recent_videos).to eq([wd, bb])
    end

    it "returns all of the videos if there are less than 6 videos" do
      action = Category.create(name: "action")

      bb = Video.create(title:"Breaking bed", description: "Good")
      wd = Video.create(title: "The walking dead", description: "Good good")
      action.videos << bb
      action.videos << wd

      expect(action.recent_videos.count).to eq(2)
    end

    it "returns 6 videos if there are more than 6 videos" do
      action = Category.create(name: "action")
      7.times.each do
        video = Video.create(title:"foo", description: "bar")
        action.videos << video
      end

      expect(action.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      action = Category.create(name: "action")
      6.times.each do
        video = Video.create(title:"foo", description: "bar")
        action.videos << video
      end
      good_show = Video.create(title:"good", description:"good", created_at: 1.day.ago)
      action.videos << good_show

      expect(action.recent_videos).not_to include(good_show)
    end

    it "returns an empty array if the category does not have any videos" do
      action = Category.create(name: "action")
      expect(action.recent_videos).to eq([])
    end
  end
end