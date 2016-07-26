require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of logged user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it "redirect to the my queue page" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates queue item that is associates with video" do
      set_current_user
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to  eq(video)
    end

    it "creates queue item that is associates with the sign in user" do
      doris = Fabricate(:user)
      set_current_user(doris)
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to  eq(doris)
    end

    it "puts the videos as the last one in the queue" do
      user = Fabricate(:user)
      set_current_user(user)
      video1 = Fabricate(:video)
      video2 = Fabricate(:video)
      Fabricate(:queue_item, video: video1, user: user)
      post :create, video_id: video2.id
      video2_queue_item = QueueItem.where(video: video2, user: user).first
      expect(video2_queue_item.position).to eq(2)
    end

    it "does not add the video in the queue if the video is already in the queue" do
      user = Fabricate(:user)
      set_current_user(user)
      video = Fabricate(:video)
      QueueItem.create(user: user, video: video)
      post :create, video_id: video.id
      expect(user.queue_items.count).to eq(1)
    end

    it_behaves_like "require sign in" do
      let(:action) { 
        video = Fabricate(:video)
        post :create, video_id: video.id
      }
    end
  end

  describe "DELETE destory" do
    it "redirects to the my queue page" do
      set_current_user
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queu item" do
      jay = Fabricate(:user)
      set_current_user(jay)
      queue_item = Fabricate(:queue_item, user: jay)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes remaining queue_items" do
      user = Fabricate(:user)
      set_current_user(user)
      queue_item1 = Fabricate(:queue_item, user: user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: user, position: 2)
      post :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it "does not delete the queue item if the queue item is not in the current user's queue" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: bob)
      set_current_user(alice)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "require sign in" do
      let(:action) { 
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
      }
    end
  end

  describe "POST update_queue" do
    context "with valid inputs" do
      let(:user) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: user, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: user, position: 2) }
      before { 
        set_current_user(user)
      }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        expect(user.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3},{id: queue_item2.id, position: 2}]
        expect(user.queue_items.map(&:position)).to eq([1 , 2])
      end
    end

    context "with invalid inputs" do
      let(:user) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: user, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: user, position: 2) }
      before { 
        set_current_user(user)
      }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1.5},{id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 1.5},{id: queue_item2.id, position: 1}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3},{id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it_behaves_like "require sign in" do
        let(:action) { 
          user = Fabricate(:user)
          queue_item1 = Fabricate(:queue_item, user: user, position: 1)
          queue_item2 = Fabricate(:queue_item, user: user, position: 2)
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        }
      end

    end

    context "with queue items that do not belong to the current user" do
      it "does not change the queue items" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        set_current_user(user1)
        queue_item1 = Fabricate(:queue_item, user: user1, position: 1)
        queue_item2 = Fabricate(:queue_item, user: user2, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2},{id: queue_item2.id, position: 1}]
        expect(queue_item2.reload.position).to eq(2)
      end
    end
  end
end