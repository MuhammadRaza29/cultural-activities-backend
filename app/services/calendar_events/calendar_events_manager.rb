class CalendarEvents::CalendarEventsManager
  attr_reader :name

  def initialize(name)
    @name = name
  end

  class << self
    def call(name)
      new(name).call
    end
  end

  def call
    "CalendarEvents::#{name.capitalize}".constantize.new.call
  end
end
