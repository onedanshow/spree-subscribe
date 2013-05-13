require 'spec_helper'

describe Spree::Subscription do
  before(:all) do
    # DD: need a fake payment method for test environment
    Factory(:authorize_net_payment_method)
  end

  context "that is in 'cart' state" do
    before(:each) do
      @sub = Factory(:subscription)
    end

    it "should have no reorder date" do
      @sub.line_item.should be
      @sub.state.should eq("cart")
      @sub.reorder_on.should be_nil
    end

    it "should have reorder date that is three months (i.e. subscription interval) from today on activation" do
      @sub.activate
      @sub.reorder_on.should eq(Date.today + 3.month)
    end

    it "should have a billing address on activation" do
      @sub.line_item.order.billing_address.should be
      @sub.billing_address.should be_nil
      @sub.activate
      @sub.billing_address.should be
    end

    it "should have a shipping address on activation" do
      @sub.line_item.order.shipping_address.should be
      @sub.shipping_address.should be_nil
      @sub.activate
      @sub.shipping_address.should be
    end

    it "should have a ship method on activation" do
      @sub.shipping_method.should be_nil
      @sub.activate
      @sub.shipping_method.should be
    end

    it "should have a payment method on activation" do
      @sub.payment_method.should be_nil
      @sub.activate
      @sub.payment_method.should be
    end

    it "should have a payment source on activation" do
      @sub.source.should be_nil
      @sub.activate
      @sub.source.should be
    end
  end

  context "that is ready for reorder" do
    before(:each) do
      @sub = Factory(:subscription_for_reorder)
      @sub.activate
    end

    it "should have reorder reset" do
      @sub.reorder_on.should eq(Date.today)
      @sub.reorder.should be_true
      @sub.reorder_on.should eq(Date.today + 3.month)
    end

    it "should have a valid order" do
      @sub.reorder.should be_true
      @sub.reorders.count.should eq(1)
    end

    it "should have a valid order with a billing address" do
      @sub.reorder.should be_true
      order = @sub.reorders.first
      order.bill_address.should be(@sub.billing_address)
    end

    it "should have a valid order with a shipping address" do
      @sub.reorder.should be_true
      order = @sub.reorders.first
      order.ship_address.should be(@sub.shipping_address)
    end

    it "should have a valid order with a shipping method" do
      @sub.reorder.should be_true
      order = @sub.reorders.first
      order.shipping_method.should be(@sub.shipping_method)
    end

    it "should have a valid order with a payment method" do
      @sub.reorder.should be_true
      order = @sub.reorders.first
      order.payment_method.should be(@sub.payment_method)
    end

    it "should have a valid order with a payment source" do
      @sub.reorder.should be_true
      order = @sub.reorders.first
      order.source.should be(@sub.source)
    end

    it "should have a payment" do
      @sub.reorder.should be_true
      order = @sub.reorders.first
      order.payments.should be
    end

    it "should have a completed order" do
      @sub.reorder.should be_true
      order = @sub.reorders.first
      order.state.should eq("complete")
      order.completed?.should be
    end
  end
end

