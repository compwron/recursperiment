module Frequency
  Daily = 1.day
  def Multiday(day_increment)
    Proc.new(day_increment.days)
 end
  Weekly = 1.week
  Biweekly = 2.weeks
  Monthly = 1.month
  Bimonthly = 2.months
  Yearly = 1.year
  Biyearly = 2.years
end
