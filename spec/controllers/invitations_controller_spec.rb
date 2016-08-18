require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end

    it_behaves_like "require sign in" do
      let(:action) { 
        get :new
      }
    end
  end

  describe "POST create" do
    context "with invalid input" do
      before {
        set_current_user
        post :create, invitation:{ recipient_name: "Joanne Wu"}
      }

      it "wonldn't create new invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "wonldn't send the mail" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "render to new page" do
        expect(response).to render_template :new
      end

      it "show error message" do
        expect(flash[:error]).to be_present
      end
    end

    context "with valid input" do
      before {
        set_current_user
        post :create, invitation: { recipient_email: "joanne@example.com", recipient_name: "Joanne Wu", message: "Come to join myflix!" }
      }

      after {ActionMailer::Base.deliveries.clear}

      it "creates invitation" do
        expect(Invitation.count).to eq(1)
      end

      it "send email to recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joanne@example.com"])
      end

      it "redirect to new invitation page" do
        expect(response).to redirect_to new_invitation_path
      end

      it "show send message" do
        expect(flash[:success]).to be_present
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { 
        post :create
      }
    end
  end
end