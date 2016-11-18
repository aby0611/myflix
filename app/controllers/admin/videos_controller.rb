class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_param)
    if @video.save
      flash[:success] = "Your video had been created successfully"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Video create fail"
      render :new
    end
  end

  private
  def video_param
    params.require(:video).permit(:title, :category_ids, :description, :large_cover, :small_cover, :video_url)
  end
end