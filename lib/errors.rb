module Error
  module InvalidSubscription
    EndDateOrDuration =  'Needs end date or duration'
    StartDateAndAmount = 'Needs start date and price'
    ConflictingEndDateOptions = 'Do not provide multiple ways to calculate subscription end date'
    FrequencySize = 'Cannot bill more than daily or less than biyearly'
  end
end
