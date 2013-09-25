require 'spec_helper'

describe Spree::OrderMailer do
  describe '#reorder_email' do
    let(:order) { create :order }
    let(:subject) { Spree::OrderMailer }

    it 'should send a reorder email' do
      email = subject.reorder_email(order)

      expect(email.subject).to eql("Spree Demo Site reminder subscription payment #{order.number}")
    end
  end
end
