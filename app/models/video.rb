class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["myfilx", Rails.env].join('_')

  has_many :video_categories
  has_many :reviews, -> { order("created_at DESC") }
  has_many :categories, ->{ order(:name) }, through: :video_categories
  has_many :queue_items

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def self.rating
    video
  end
end