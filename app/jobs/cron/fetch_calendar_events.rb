require 'sidekiq'
require 'sidekiq-scheduler'

module Cron
  class FetchCalendarEvents
    include Sidekiq::Worker

    def perform
      WEB_SOURCES.each do |k, _v|
        SyncCalendarEventsJob.perform_now(k)
      end
    end
  end
end
