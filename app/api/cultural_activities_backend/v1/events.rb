module CulturalActivitiesBackend
  module V1
    class Events < API
      helpers do
        def event_data(event)
          date = event.start_date.to_s
          date += " - #{event.end_date}" if event.end_date.present?
          time = event.start_time.strftime("%H:%M %p") rescue ''
          time += " - #{event.end_time.strftime("%H:%M %p")}" if event.end_time.present?
          {
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
      end

      resources :events do
        desc 'Fetch All Calendar Events'
        get do
          all_events = Event.active
          if params[:search].present?
            search_params = JSON.parse(params[:search]).with_indifferent_access
            all_events = if search_params[:title].present?
              Event.active.search_by('title', search_params[:title])
            elsif search_params[:web_source].present?
              Event.active.search_by('web_source', search_params[:web_source])
            else
              Event.active.search_by_date(search_params[:date])
            end
          end
          all_events = all_events.page(params[:page])
          events = []
          all_events.each do |event|
            events << event_data(event)
          end
          { total_pages: all_events.total_pages, total_events: all_events.total_count, events: events }
        end
      end
    end
  end
end
