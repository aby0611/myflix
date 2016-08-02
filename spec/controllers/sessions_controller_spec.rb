require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "render :new if no logined user" do
      get :new
      expect(response).to render_template :new
    end
    it "redirect to home page if there's login user" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid input" do
      let(:steven) { Fabricate(:user) }
      before {
        post :create, email: steven.email, password: steven.password
      }
      it "put the session if there is authenticate user" do
        expect(session[:user_id]).to eq(steven.id)
      end
      it "redirect home page" do
        expect(response).to redirect_to home_path
      end
      it "set notice" do
        expect(flash[:notice]).not_to be_blank
      end
    end
    context "with invalid input" do
      before {
        steven = Fabricate(:user)
        post :create, email: steven.email, password: "abcdefghijk"
      }
      it "won't assign sesion" do
        expect(session[:user_id]).to be_nil
      end
      it "redirect sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      it "set error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe "GET destory" do
    before {
      session[:user_id] = Fabricate(:user).id
      get :destroy
    }
    it "clear session" do
      expect(session[:user_id]).to be_nil
    end
    it "redirect to sign in path" do
      expect(response).to redirect_to sign_in_path
    end
    it "set notice" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end