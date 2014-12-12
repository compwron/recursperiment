class Subscription
  attr_reader :start_date, :end_date, :frequency, :price
  def initialize(options)
    @start_date = options[:start_date]
    @end_date = _end_date_from(options)
    @frequency = options[:frequency]
    @price = options[:price]
    @skips = options[:skip] || []
  end

  def _end_date_from(options)
    return options[:end_date] if options[:end_date]
    return options[s: tart_date] + options[:duration] if options[:duration]
    fail new InvalidSubscriptionError('Needs end date or duration')
  end

  def skips?(date)
    @skips.include? date
  end

  def bills_on?(date)
  	return false if skips? date
  	(@start_date.to_i..@end_date.to_i).step(@frequency) do |d|
    	puts "evaluating #{Time.at(d)}"
      return true if d === date.to_i
    end
    false
  end
end

