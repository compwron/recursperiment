require_relative 'spec_helper'

describe Subscription do
  let(:some_price) { OpenStruct.new(amount: 100, currency: Currency::USD) }
  let(:options) do
    {
      start_date: DateTime.new(2015, 1, 1),
      end_date: DateTime.new(2016, 1, 1),
      frequency: Frequency::Monthly,
      price: some_price,
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

    it 'must have start date and amount' do
      expect { Subscription.new({}) }.to raise_error(/Needs end date or duration/)
    end
  end

  describe 'next_billing_date' do
    it 'gives end date if end date is in the past' do
      time = Time.parse('2017/01/01 00:00:00 UTC')
      Timecop.freeze(time) do
        expect(s.next_billing_date).to eq DateTime.new(2016, 1, 1)
      end
    end

    it 'knows next billing date is today' do
      time = Time.parse('2015/01/01 00:00:00 UTC')
      Timecop.freeze(time) do
        expect(s.next_billing_date).to eq DateTime.new(2015, 1, 1)
      end
    end

    it 'knows next billing date is next month' do
      time = Time.parse('2015/01/03 00:00:00 UTC')
      Timecop.freeze(time) do
        expect(s.next_billing_date).to eq DateTime.new(2015, 1, 31) # DateTime.new(2015, 2, 1) when end_of_month works
      end
    end

    it 'knows to bill next week' do
      options = {
        start_date: DateTime.new(2015, 1, 1),
        end_date: DateTime.new(2016, 1, 1),
        frequency: Frequency::Biweekly,
        price: some_price
      }
      s = Subscription.new(options)
      time = Time.parse('2015/01/02 00:00:00 UTC')
      Timecop.freeze(time) do
        expect(s.next_billing_date).to eq DateTime.new(2015, 1, 15)
      end
    end

    it 'weekly recur'

    it 'can recur in multiday increments'
  end

  describe 'frequency' do
    it 'weekly'
    it 'biweekly'
    it 'every third day'
    it 'yearly'
    it 'biyearly' # this is probably a bad idea; who can remember things that long?
    it 'biweekly and then weekly after two months'
    it 'discount on a specific date'
    it 'different price every other billing cycle'
  end

  describe 'update_price' do
    it 'does not change past billing events' # eventually make this an activerecord thing
  end

  describe 'end_date' do
    it 'derives end date from start date and duration' do
      options = {
        start_date: DateTime.new(2015, 1, 1),
        duration: 6.months,
        price: some_price
      }
      expect(Subscription.new(options).end_date).to eq DateTime.new(2015, 7, 1)
    end

    it 'derives end date from start date, frequency, and number of instances' do
      options = {
        start_date: DateTime.new(2015, 1, 1),
        frequency: 2.months,
        number_of_billing_events: 3, # name this better?
        price: some_price
      }
      expect(Subscription.new(options).end_date).to eq DateTime.new(2015, 5, 1)
    end
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
          price: some_price,
          skip: [DateTime.new(2015, 1, 1)]
        )
      expect(s.bills_on? DateTime.new(2015, 1, 1)).to eq false
    end

    xit 'same day of month as it started' do # pending redesign of incrementing dates
      s = Subscription.new(
         start_date: DateTime.new(2015, 1, 1),
         end_date: DateTime.new(2016, 1, 1),
         frequency: Frequency::Monthly,
         price: some_price
       )
      expect(s.bills_on? DateTime.new(2015, 2, 1)).to eq true
    end

    xit 'ends on next day of month after it started if same day does not exist' do # pending redesign of incrementing dates
      s = Subscription.new(
          start_date: DateTime.new(2015, 1, 30),
          end_date: DateTime.new(2016, 1, 1),
          frequency: Frequency::Monthly,
          price: some_price
        )
      expect(s.bills_on? DateTime.new(2015, 2, 28)).to eq false
      expect(s.bills_on? DateTime.new(2015, 3, 1)).to eq true
      expect(s.bills_on? DateTime.new(2015, 3, 30)).to eq true
    end

    # if billing in month or multimonth increments, bill on the same day of the month.
    # If that day of the month does not exist, bill on the first day of the next month.
    # If you have billed on the first of a month, bill that month still on the last day of its month.
  end

  # subscriptionservice will make a transaction from all subscriptions which will bill on that day - cronjob?

  it 'validates start date and end date are dates, returns polite error if not'
  it 'is ok to make past subscription but there will be no actually_billed_on'
  it 'updates actually_billed_on unless an error occurs during billing'
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
