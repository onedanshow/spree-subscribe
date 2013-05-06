require 'spec_helper'

describe Spree::SubscriptionInterval do
  it "has a 3 month time period" do
    interval = Factory(:subscription_interval)
    interval.time.should eq(3.months)
  end
end
