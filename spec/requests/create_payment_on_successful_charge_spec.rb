require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do {
    "id" => "evt_19FmZFCZ1MGj1bP5AXz0YMUV",
    "object" => "event",
    "api_version" => "2016-07-06",
    "created" => 1479138021,
    "data" => {
      "object" => {
        "id" => "ch_19FmZFCZ1MGj1bP5ZouMBBtf",
        "object" => "charge",
        "amount" => 999,
        "amount_refunded" => 0,
        "application" => nil,
        "application_fee" => nil,
        "balance_transaction" => "txn_19FmZFCZ1MGj1bP52TvI6V0j",
        "captured" => true,
        "created" => 1479138021,
        "currency" => "usd",
        "customer" => "cus_9YuOh5rgmxDRqQ",
        "description" => nil,
        "destination" => nil,
        "dispute" => nil,
        "failure_code" => nil,
        "failure_message" => nil,
        "fraud_details" => {},
        "invoice" => "in_19FmZECZ1MGj1bP5Iazqj6NY",
        "livemode" => false,
        "metadata" => {},
        "order" => nil,
        "outcome" => {
          "network_status" => "approved_by_network",
          "reason" => nil,
          "risk_level" => "normal",
          "seller_message" => "Payment complete.",
          "type" => "authorized"
        },
        "paid" => true,
        "receipt_email" => nil,
        "receipt_number" => nil,
        "refunded" => false,
        "refunds" => {
          "object" => "list",
          "data" => [],
          "has_more" => false,
          "total_count" => 0,
          "url" => "/v1/charges/ch_19FmZFCZ1MGj1bP5ZouMBBtf/refunds"
        },
        "review" => nil,
        "shipping" => nil,
        "source" => {
          "id" => "card_19FmZDCZ1MGj1bP5802q5iJX",
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
          "customer" => "cus_9YuOh5rgmxDRqQ",
          "cvc_check" => "pass",
          "dynamic_last4" => nil,
          "exp_month" => 11,
          "exp_year" => 2019,
          "fingerprint" => "bjfc43xeR1DYZ8p1",
          "funding" => "credit",
          "last4" => "4242",
          "metadata" => {},
          "name" => nil,
          "tokenization_method" => nil
        },
        "source_transfer" => nil,
        "statement_descriptor" => "Subscribe it!",
        "status" => "succeeded"
      }
    },
    "livemode" => false,
    "pending_webhooks" => 1,
    "request" => "req_9YuOxnMVuNzMq0",
    "type" => "charge.succeeded"
  }
  end

  it "create a payment with the webhook from stripe for charge succeeded" do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user" do
    alice = Fabricate(:user, customer_token: "cus_9YuOh5rgmxDRqQ")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount" do
    alice = Fabricate(:user, customer_token: "cus_9YuOh5rgmxDRqQ")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id" do
    alice = Fabricate(:user, customer_token: "cus_9YuOh5rgmxDRqQ")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_19FmZFCZ1MGj1bP5ZouMBBtf")
  end
end