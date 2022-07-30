class SyncCalendarEventsJob < ApplicationJob
  queue_as :default

  def perform(name)
    CalendarEvents::CalendarEventsManager.call(name)
  end
end
