require 'spec_helper'

describe "Deactived user on failed charge" do
  let(:event_data) do {
    "id" => "evt_19HB8rCZ1MGj1bP5r72GKqpU",
    "object" => "event",
    "api_version" => "2016-07-06",
    "created" => 1479470813,
    "data" => {
      "object" => {
        "id" => "ch_19HB8rCZ1MGj1bP5Ob3aeACq",
        "object" => "charge",
        "amount" => 999,
        "amount_refunded" => 0,
        "application" => nil,
        "application_fee" => nil,
        "balance_transaction" => nil,
        "captured" => false,
        "created" => 1479470813,
        "currency" => "usd",
        "customer" => "cus_9ZoBlq3gG4OeUn",
        "description" => "",
        "destination" => nil,
        "dispute" => nil,
        "failure_code" => "card_declined",
        "failure_message" => "Your card was declined.",
        "fraud_details" => {},
        "invoice" => nil,
        "livemode" => false,
        "metadata" => {},
        "order" => nil,
        "outcome" => {
          "network_status" => "declined_by_network",
          "reason" => "generic_decline",
          "risk_level" => "normal",
          "seller_message" => "The bank did not return any further details with this decline.",
          "type" => "issuer_declined"
        },
        "paid" => false,
        "receipt_email" => nil,
        "receipt_number" => nil,
        "refunded" => false,
        "refunds" => {
          "object" => "list",
          "data" => [],
          "has_more" => false,
          "total_count" => 0,
          "url" => "/v1/charges/ch_19HB8rCZ1MGj1bP5Ob3aeACq/refunds"
        },
        "review" => nil,
        "shipping" => nil,
        "source" => {
          "id" => "card_19HB8bCZ1MGj1bP5d44Titnk",
          "object" => "card",
          "address_city" => nil,
          "address_country" => nil,
          "address_line1" => nil,
          "address_line1_check" => nil,
          "address_line2" => nil,
          "address_state" => nil,
          "address_zip" => nil,
          "address_zip_check" => nil,
          "brand" => "Visa",
          "country" => "US",
          "customer" => "cus_9ZoBlq3gG4OeUn",
          "cvc_check" => "pass",
          "dynamic_last4" => nil,
          "exp_month" => 11,
          "exp_year" => 2022,
          "fingerprint" => "uia3o5u1wkJDOZ1z",
          "funding" => "credit",
          "last4" => "0341",
          "metadata" => {},
          "name" => nil,
          "tokenization_method" => nil
        },
        "source_transfer" => nil,
        "statement_descriptor" => nil,
        "status" => "failed"
      }
    },
    "livemode" => false,
    "pending_webhooks" => 1,
    "request" => "req_9aLqm5saFPGQa1",
    "type" => "charge.failed"
  }
  end

  it "deacticates a user with the web hook data from stripe for charge failed" do
    alice = Fabricate(:user, customer_token: "cus_9ZoBlq3gG4OeUn")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end

end