class Failure
  attr_reader :message
  def initialize(errors)
    @message = errors.join('||')
  end
end
