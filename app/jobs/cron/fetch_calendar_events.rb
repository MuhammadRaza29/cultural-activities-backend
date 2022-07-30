module Cron
  class FetchCalendarEvents < ApplicationJob
    def perform
      WEB_SOURCES.each do |k, _v|
        SyncCalendarEventsJob.perform_now(k)
      end
    end
  end
end
