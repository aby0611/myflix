class Category < ActiveRecord::Base
  has_many :video_categories
  has_many :videos, ->{ order("created_at DESC") }, through: :video_categories

  validates :name, presence: true

  def recent_videos
    videos.first(6)
  end
end