require 'spec_helper'

describe Spree::Subscription do

  context "that is in 'cart' state" do
    before(:each) do
      @sub = create :subscription
      @sub.line_item.order.reload
    end

    it "should have no reorder date" do
      @sub.line_item.should be
      @sub.state.should eq("cart")
      @sub.reorder_on.should be_nil
    end

    it "should have reorder date that is three months (i.e. subscription interval) from today on activation" do
      @sub.start
      @sub.reorder_on.should eq(Date.today + 3.month)
    end

    it "should have a billing address on activation" do
      @sub.line_item.order.bill_address.should be
      @sub.billing_address.should be_nil
      @sub.start
      @sub.billing_address.should be
    end

    it "should have a shipping address on activation" do
      @sub.line_item.order.shipping_address.should be
      @sub.shipping_address.should be_nil
      @sub.start
      @sub.shipping_address.should be
    end

    it "should have a ship method on activation" do
      @sub.line_item.order.shipment_for_variant( @sub.line_item.variant ).should be
      @sub.shipping_method.should be_nil
      @sub.start
      @sub.shipping_method.should be
    end

    it "should have a payment method on activation" do
      @sub.payment_method.should be_nil
      @sub.start
      @sub.payment_method.should be
    end

    it "should have a payment source on activation" do
      @sub.source.should be_nil
      @sub.start
      @sub.source.should be
    end

    it "should have a user on activation" do
      @sub.user.should be_nil
      @sub.start
      @sub.user.should be
    end
  end

  context "that is ready for reorder" do
    before(:each) do
      @sub = create(:subscription_for_reorder)
      @sub.start
      # DD: calling start will set date into future
      @sub.update_attribute(:reorder_on,Date.today)
    end

    it "should have reorder_on reset" do
      @sub.reorder_on.should eq(Date.today)
      @sub.reorder.should be_true
      @sub.reorder_on.should eq(Date.today + 3.month)
    end

    it "should have a valid order" do
      @sub.reorder.should be_true
      @sub.reorders.count.should eq(1)
    end

    it "should have a valid order with a billing address" do
      @sub.create_reorder.should be_true
      order = @sub.reorders.first
      order.bill_address.should == @sub.billing_address  # DD: uses == operator override in Spree::Address
      order.bill_address.id.should_not eq @sub.billing_address.id # DD: not the same database record
    end

    it "should have a valid order with a shipping address" do
      @sub.create_reorder.should be_true
      order = @sub.reorders.first
      order.ship_address.should == @sub.shipping_address  # DD: uses == operator override in Spree::Address
      order.ship_address.id.should_not eq @sub.shipping_address.id # DD: not the same database record
    end

    it "should have a valid line item" do
      @sub.create_reorder
      @sub.add_subscribed_line_item.should be_true
      order = @sub.reorders.first
      order.line_items.count.should eq(1)
    end

    it "should have a valid order with a shipping method" do
      @sub.reorder
      @sub.add_subscribed_line_item
      @sub.select_shipping.should be_true

      order = @sub.reorders.first
      order.shipments.count.should eq(1)

      s = order.shipments.first
      expect(s.shipping_method).to eq @sub.shipping_method  # DD: should be same database record
    end

    it "should have a valid order with a payment method" do
      @sub.reorder

      order = @sub.reorders.first
      order.payments.count.should eq(1)

      payment = order.payments.first
      expect(payment.payment_method).to eq @sub.payment_method  # DD: should be same database record
    end

    it "should have a valid order with a payment source" do
      @sub.reorder

      order = @sub.reorders.first
      order.payments.count.should be(1)
      expect(order.payments.first.source).to eq @sub.source  # DD: should be same database record
    end

    it "should have a payment" do
      @sub.reorder

      order = @sub.reorders.first
      order.payments.should be
    end

    it "should have a completed order" do
      #TODO fb, should return the state to complete, before conekta supports recurrent payments
      @sub.reorder.should be_true

      order = @sub.reorders.first
      order.state.should eq("payment")
      #order.completed?.should be
    end

    it "should send a reorder email reminder" do
      Spree::Order.any_instance.should_receive(:deliver_reorder_confirmation_email)
      @sub.reorder

      order = @sub.reorders.first
      order.state.should eq("payment")
    end
  end

end

