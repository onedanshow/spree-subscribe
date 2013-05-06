require 'spec_helper'

describe Spree::Subscription do
  context "a plain Spree::Subscription" do
    before(:each) do
      @sub = Factory(:subscription)
    end

    it "should have no reorder date when in state cart" do
      @sub.state.should eq("cart")
      @sub.reorder_on.should be_nil
    end

    it "should have reorder date that is three months (i.e. subscription interval) from today on activation" do
      @sub.activate
      @sub.reorder_on.should eq(Date.today + 3.month)
    end
  end

  context "a Spree::Subscription ready for reorder" do
    before(:each) do
      @sub = Factory(:subscription_for_reorder)
    end

    it "should have reorder reset" do
      @sub.reorder_on.should eq(Date.today)
      @sub.reorder
      @sub.reorder_on.should eq(Date.today + 3.month)
    end
  end
end

