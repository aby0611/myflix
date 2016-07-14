class QueueItemsController < ApplicationController
  before_filter do
    redirect_to :root if Rails.env.production?
  end
  before_filter :require_user

  layout "application"

  def index
    @queue_items = current_user.queue_items
  end

  def create
    QueueItem.create
    redirect_to my_queue_path
  end
end