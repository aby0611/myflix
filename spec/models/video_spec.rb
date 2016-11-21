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

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end
  end
end