require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of logged user" do
      alice = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      session[:user_id] = alice.id
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirect to sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do
    it "redirect to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end
    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end
    it "creates queue item that is associates with video" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to  eq(video)
    end
    it "creates queue item that is associates with the sign in user" do
      doris = Fabricate(:user)
      session[:user_id] = doris.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to  eq(doris)
    end
    it "puts the videos as the last one in the queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      Fabricate(:queue_item, video: video1, user: user)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video: video2, user: user).first
      expect(video2_queue_item.position).to eq(2)
    end
    it "does not add the video in the queue if the video is already in the queue" do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      QueueItem.create(user: user, video: video)
      post :create, video_id: video.id
      expect(user.queue_items.count).to eq(1)
    end
    it "rediect to the sign in page for unauthenticated users" do
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end
end