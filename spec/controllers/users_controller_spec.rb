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

    context "sending emails" do
      after {ActionMailer::Base.deliveries.clear}

      it "sends out email to the user with valid inputs" do
        post :create, user: {email: "steven@example.com", password: "password", full_name: "Steven Huang"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["steven@example.com"])
      end

      it "sends out email containing user's name with valid input" do
        post :create, user: {email: "steven@example.com", password: "password", full_name: "Steven Huang"}
        expect(ActionMailer::Base.deliveries.last.body).to include("Steven Huang")
      end

      it "does not send out email with invalid input" do
        post :create, user: {email: "steven@example.com"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end