require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    let(:customer) { double(:customer, successful?: true, customer_token: "abcdef") }
    before {
      StripeWrapper::Customer.should_receive(:create).and_return(customer)
    }

    after {ActionMailer::Base.deliveries.clear}

    context "valid personal info and valid card" do
      it "creates user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.first.customer_token).to eq("abcdef")
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joanne@example.com")
        UserSignup.new(Fabricate.build(:user, email: "joanne@example.com", password: "password", full_name: "Joanne Wu")).sign_up("some_stripe_token", invitation.token)
        joanne = User.where(email: "joanne@example.com").first
        expect(joanne.follows?(alice)).to be_truthy
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joanne@example.com")
        UserSignup.new(Fabricate.build(:user, email: "joanne@example.com", password: "password", full_name: "Joanne Wu")).sign_up("some_stripe_token", invitation.token)
        joanne = User.where(email: "joanne@example.com").first
        expect(alice.follows?(joanne)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "joanne@example.com")
        UserSignup.new(Fabricate.build(:user, email: "joanne@example.com", password: "password", full_name: "Joanne Wu")).sign_up("some_stripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end

      it "sends out email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: "steven@example.com", password: "password", full_name: "Steven Huang")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["steven@example.com"])
      end

      it "sends out email containing user's name with valid input" do
        UserSignup.new(Fabricate.build(:user, email: "steven@example.com", password: "password", full_name: "Steven Huang")).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Steven Huang")
      end
    end
  end

  context "valid personal info and declined card" do
    let(:customer) { double(:customer, successful?: false, error_message: "Your card was declined.") }
    before {
      StripeWrapper::Customer.should_receive(:create).and_return(customer)

      UserSignup.new(Fabricate.build(:user)).sign_up("1231241", nil)
    }

    it "does not create a new user record" do
      expect(User.count).to eq(0)
    end
  end

  context "invalid personal info" do
    before {
      ActionMailer::Base.deliveries.clear
    }

    it "doesn't create user" do
      UserSignup.new(User.new(email: "steven@example.com")).sign_up("1231241", nil)
      expect(User.count).to eq(0)
    end

    it "does not charge the card" do
      StripeWrapper::Customer.should_not_receive(:create)
      UserSignup.new(User.new(email: "steven@example.com")).sign_up("1231241", nil)
    end

    it "does not send out email with invalid input" do
      UserSignup.new(User.new(email: "steven@example.com")).sign_up("1231241", nil)
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end