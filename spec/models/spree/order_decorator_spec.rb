require 'spec_helper'

describe Spree::Order do

  describe '#deliver_reorder_confirmation_email' do
    before do
      @order = create :order
    end

    it 'should send an email' do
      Spree::OrderMailer.should_receive(:reorder_email).with(@order)
      @order.deliver_reorder_confirmation_email
    end
  end
end
