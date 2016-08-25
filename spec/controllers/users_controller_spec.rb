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

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joanne@example.com")
        post :create, user: {email: "joanne@example.com", password: "password", full_name: "Joanne Wu"}, invitation_token: invitation.token
        joanne = User.where(email: "joanne@example.com").first
        expect(joanne.follows?(alice)).to be_truthy
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joanne@example.com")
        post :create, user: {email: "joanne@example.com", password: "password", full_name: "Joanne Wu"}, invitation_token: invitation.token
        joanne = User.where(email: "joanne@example.com").first
        expect(alice.follows?(joanne)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joanne@example.com")
        post :create, user: {email: "joanne@example.com", password: "password", full_name: "Joanne Wu"}, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
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

  describe "GET new_with_invitation_token" do
    it "render the new template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: "sdfdad"
      expect(response).to redirect_to expired_token_path
    end
  end
end