require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "create User instance" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "valid input" do
      before {
        post :create, user: {email: "steven@example.com", password: "password", full_name: "Steven Huang"}
      }
      it "creates user" do
        expect(User.count).to eq(1)
      end

      it "redirect to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "invalid input" do
      before {
        post :create, user: {email: "steven@example.com"}
      }
      it "doesn't create user" do
        expect(User.count).to eq(0)
      end
      it "re-render the new user page" do
        expect(response).to render_template :new
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)

      end
    end
  end
end