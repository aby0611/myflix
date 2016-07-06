require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "monk", description: "a great video!!")
    video.save
    expect(Video.first).to eq(video)
  end

  it "does not save a video without a title" do
    video = Video.create(description: "a great video")
    video.save
    expect(Video.count).to eq(0)
  end

  it "does not save a video wothout a description" do
    video = Video.create(title: "a good title")
    video.save
    expect(Video.count).to eq(0)
  end
end