require 'spec_helper'

describe Video do
  it { should have_many(:categories)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}
  it {should have_many(:reviews).order("created_at DESC")}

  describe do
    it "returns an empty array if there's no match" do
      futurama = Video.create(title: "Futurama", description: "Some description")
      back_future = Video.create(title: "Back to Future", description: "Some description")
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      futurama = Video.create(title: "Futurama", description: "Some description")
      back_future = Video.create(title: "Back to Future", description: "Some description")
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end

    it "returns an array of one video for a partial match" do
      futurama = Video.create(title: "Futurama", description: "Some description")
      back_future = Video.create(title: "Back to Future", description: "Some description")
      expect(Video.search_by_title("rama")).to eq([futurama])
    end

    it "returns an array of all matches ordered by created_at" do
      futurama = Video.create(title: "Futurama", description: "Some description", created_at: 1.day.ago)
      back_future = Video.create(title: "Back to Future", description: "Some description")
      expect(Video.search_by_title("Futur")).to eq([back_future, futurama])
    end

    it "returns an empty array for a search with an empty string" do
      futurama = Video.create(title: "Futurama", description: "Some description")
      back_future = Video.create(title: "Back to Future", description: "Some description")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end