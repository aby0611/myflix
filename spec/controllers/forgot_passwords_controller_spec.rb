require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "directs to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        post :create, email: ''
        expect(flash[:error]).to eq("Email cannot be blank.")
      end
    end

    context "with existing email" do
      it "redirect to the forgot password confirmation page" do
        Fabricate(:user, email: "steven@example.com")
        post :create, email: "steven@example.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends out an email to the email address" do
        Fabricate(:user, email: "steven@example.com")
        post :create, email: "steven@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["steven@example.com"])
      end
    end

    context "with non-exitsting email" do
      it "redirects to the forgot password page" do
        post :create, email: "foo@example.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        post :create, email: "foo@example.com"
        expect(flash[:error]).to eq("This email doesn't exist")
      end
    end
  end
end