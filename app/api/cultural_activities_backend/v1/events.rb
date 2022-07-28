module CulturalActivitiesBackend
  module V1
    class Events < API
      resources :events do
        desc 'Fetch All Calendar Events'
        get do
          all_events = Event.active.page(params[:page])
          events = []
          all_events.each do |event|
            date = event.start_date.to_s
            date += " - #{event.end_date}" if event.end_date.present?
            time = event.start_time.to_s
            time += " - #{event.end_time}" if event.end_time.present?
            events << {
              id: event.id,
              title: event.title,
              description: event.description,
              url: event.url,
              picture_url: event.picture_url,
              date: date,
              time: time,
              venue_name: event.event_venue_name,
              category: event.category_name
            }
          end
          { total_pages: all_events.total_pages, total_events: all_events.total_count, events: events }
        end
      end
    end
  end
end
