class AddLargeCoverAndSmallCoverToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :large_cover, :string
    add_column :videos, :small_cover, :string
    remove_column :videos, :large_video_cover
    remove_column :videos, :small_video_cover
  end
end
