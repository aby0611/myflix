require 'spec_helper'

describe VideosController do
  describe "GET show" do
    context "with authenticated users" do
      before do
        session[:user_id] = Fabricate(:user).id
      end

      it "sets @video" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end
    end

    context "with unauthenticated users" do
      it "redirects user to the sign in page" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      bb = Fabricate(:video, title: "Breaking bad")
      post :search, search_term: "bad"
      expect(assigns(:results)).to eq([bb])
    end

    it "redirects to sign in path for unauthenticated users" do
      bb = Fabricate(:video, title: "Breaking bad")
      post :search, search_term: "bad"
      expect(response).to redirect_to sign_in_path
    end
  end
end