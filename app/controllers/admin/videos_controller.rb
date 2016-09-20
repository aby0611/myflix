class Admin::VideosController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params.require(:video).permit(:title, :category_ids, :description))
    if @video.save
      flash[:success] = "Your video had been created successfully"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Video create fail"
      render :new
    end
  end

  private

  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to home_path unless current_user.admin?
    end
  end
end