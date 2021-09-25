class NMachine
  InvalidEventError = Class.new(ArgumentError)

  attr_reader :state

  def initialize(initial_state)
    @state = initial_state
    @events = Hash.new
  end

  def when(event, transistions = {}, &block)
    @events[event] = [transistions, block]
  end

  private

  def transition(event)
    ensure_allowed(event)
    @state = @events[event][0][state]
    @events[event][1]&.call
    self
  end

  def ensure_allowed(event)
    raise InvalidEventError.new("#{event} not valid from #{state}") unless @events[event][0].has_key?(state)
  end

  def method_missing(m, *args, &block)
    if @events.has_key?(m) then transition(m) else super end
  end
end
