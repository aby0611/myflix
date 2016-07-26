require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    context "with authenticate user" do
      let(:current_user) { Fabricate(:user) }
      before { 
        session[:user_id] = current_user.id
      }

      context "with valid input" do
        it "redirect to video show page" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(response).to redirect_to video
        end

        it "creates a review" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with video" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.video).to eq(video)
        end

        it "created a review associated with sign in user" do
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid input" do
        it "does not create review" do
          video = Fabricate(:video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(Review.count).to eq(0)
        end

        it "render video/show template" do
          video = Fabricate(:video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(response).to render_template 'videos/show'
        end

        it "sets @video" do
          video = Fabricate(:video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do
          video = Fabricate(:video)
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 4}, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context "with unauthenticate user" do
      it_behaves_like "require sign in" do
        let(:action) {
          video = Fabricate(:video)
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        }
      end
    end
  end
end