require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "create User instance" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "successful user sign up" do
      it "redirect to sign in page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: {email: "steven@example.com", password: "password", full_name: "Steven Huang"}
        expect(response).to redirect_to sign_in_path
      end
    end

    context "fail user sign up" do
      before {
        result = double(:sign_up_result, successful?:false, error_message: "This is an error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "1231241"
      }

      it "renders the new template" do
        expect(response).to render_template :new
      end

      it "sets the flash error message" do
        expect(flash[:error]).to be_present
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