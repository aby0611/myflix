require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "make a successful charge" do
        Stripe.api_key = ENV['stripe_api_key']
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 10,
            :exp_year => 2017,
            :cvc => "314"
          },
        ).id

        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: "a valid charge"
        )

        expect(response.amount).to eq(999)
        expect(response.currency).to eq("usd")

      end
    end
  end
end