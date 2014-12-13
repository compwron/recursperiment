class Subscription
  attr_reader :start_date, :end_date, :frequency, :price

  def initialize(options)
    @errors = []
    _validate(options)
    @start_date = options[:start_date]
    @end_date = _end_date_from(options)
    @frequency = options[:frequency]
    @price = options[:price]
    @skips = options[:skip] || []
  end

  def next_billing_date
    return @end_date if DateTime.now > @end_date
    (DateTime.now.to_i..@end_date.to_i).step(Frequency::Daily) do|d|
      date = DateTime.strptime(d.to_s, '%s')
      return date if bills_on? date
    end
    'what even happened'
  end

  def _validate(options)
    @errors << Error::InvalidSubscription::StartDateAndAmount unless options[:start_date] && options[:price]

    frequency_strategy_possible = _frequency_strategy_possible?(options)
    @errors << Error::InvalidSubscription::EndDateOrDuration unless options[:end_date] || options[:duration] || frequency_strategy_possible
    if [options[:end_date], options[:duration], frequency_strategy_possible].compact.size > 1
      fail Error::InvalidSubscription::ConflictingEndDateOptions
    end
    # @errors << Error::InvalidSubscription::FrequencySize unless Frequency::Biyearly >= options[:frequency] && options[:frequency] >= Frequency::Daily

    fail Failure.new(@errors).message if @errors.size > 0
  end

  def _frequency_strategy_possible?(options)
    (options[:number_of_billing_events] && options[:number_of_billing_events] > 0) && options[:frequency]
  end

  def _end_date_from(options)
    return options[:end_date] if options[:end_date]
    return options[:start_date] + options[:duration] if options[:duration]
    _end_date_from_frequency(options)
  end

  def _end_date_from_frequency(options)
    a = options[:start_date]
    (1..options[:number_of_billing_events] - 1).map do|_i|
      a += options[:frequency]
    end
    a
  end

  def skips?(date)
    @skips.include? date
  end

  def bills_on?(date)
    # if billing in month or multimonth increments, bill on the same day of the month.
    # If that day of the month does not exist, bill on the first day of the next month.
    # If you have billed on the first of a month, bill that month still on the last day of its month.

    return false if skips? date
    return true if [@start_date, @end_date].include? date
    (@start_date.to_i..@end_date.to_i).step(@frequency) do |d|
      # puts "evaluating #{DateTime.strptime(d.to_s, '%s')}"
      return true if d === date.to_i
    end
    false
  end
end
