require 'sidekiq'
require 'sidekiq-scheduler'

module Cron
  class ExpirePastCalendarEvents
    include Sidekiq::Worker

    def perform
      events = Event.active.where("end_date > ? AND end_time > ?", Time.zone.today, Time.zone.now)
      events.update(status: Event::statuses[:expired])
    end
  end
end
