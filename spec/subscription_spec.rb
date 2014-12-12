require_relative 'spec_helper'

describe Subscription do
  let(:options) do
    {
      start_date: DateTime.new(2015, 1, 1),
      end_date: DateTime.new(2016, 1, 1),
      frequency: Frequency::Monthly,
      price: OpenStruct.new(amount: 100, currency: Currency::USD),
      skip: [DateTime.new(2015, 2, 1)]
    }
  end
  let(:s) { Subscription.new(options)    }

  describe 'initialize' do
    it 'has start date, optional end date, frequency, amount, and skip instructions' do
      # all dates are assumed midnight on the UTC day

      expect(s.start_date).to eq DateTime.new(2015, 1, 1)
      expect(s.end_date).to eq DateTime.new(2016, 1, 1)
      expect(s.frequency).to eq Frequency::Monthly

      price = s.price
      expect(price.amount).to eq 100
      expect(price.currency).to eq Currency::USD

      expect(s.skips? DateTime.new(2015, 2, 1)).to eq true
    end

    describe 'bills_on?' do
      it 'bills on its first billing day' do
        expect(s.bills_on? DateTime.new(2015, 1, 1)).to eq true
      end

      it 'bills on its last billing day' do
        expect(s.bills_on? DateTime.new(2016, 1, 1)).to eq true
      end

      it 'does not bill on its first billing day if that day is skipped' do
        s = Subscription.new(
            start_date: DateTime.new(2015, 1, 1),
            end_date: DateTime.new(2016, 1, 1),
            frequency: Frequency::Monthly,
            price: OpenStruct.new(amount: 100, currency: Currency::USD),
            skip: [DateTime.new(2015, 1, 1)]
          )
        expect(s.bills_on? DateTime.new(2015, 1, 1)).to eq false
      end
    end

    it 'detects skip first and last'
    it 'must have start date and amount'
    it 'frequency defaults to monthly'
    it 'must have either end date or duration'
    it 'end date is inclusive'
    it 'amount must have currency and '
    it 'errors if skip date is not used'
    it 'bills on the day of the month it was started'
    it 'bills on the next day if the day of the month it was started does not exist'
    # it ''
  end
end
