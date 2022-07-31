require 'open-uri'

class CalendarEvents::Base
  attr_accessor :event_params, :all_calendar_events
  attr_reader :web_source, :url, :response

  def initialize
    @web_source = self.class.name.split('::').last.downcase
    @url = WEB_SOURCES[web_source.to_sym]
    @all_calendar_events = []
  end

  protected
  def base_url
    URI(url).origin
  end

  def save_or_update_calendar_events
    all_calendar_events.each do |calendar_event_params|
      event = Event.find_or_initialize_by(title: calendar_event_params[:title], web_source: web_source)
      event.update(calendar_event_params)
    end
  end

  def find_event(title)
    Event.find_by_title(title)
  end

  def event_time(date, time)
    DateTime.parse("#{date} #{time}")
  end

  def has_digits?(s)
    s =~ /\d/
  end
end
