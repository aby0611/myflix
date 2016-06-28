class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :description
      t.string :large_video_cover
      t.string :small_video_cover
      t.timestamps
    end
  end
end
