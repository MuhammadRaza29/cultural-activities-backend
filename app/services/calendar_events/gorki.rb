class CalendarEvents::Gorki < CalendarEvents::Base
  def call
    fetch_and_parse_data
    save_or_update_calendar_events
  end

  private

  def fetch_and_parse_data
    @response = Nokogiri::HTML(URI.open(url))
    response.css(".schedule-filter .schedule-filter--months li .schedule-filter--months--link").each do |month|
      fetch_monthly_calendar_events(month)
    end
  end

  def fetch_monthly_calendar_events(month)
    path = month.attribute("href").value
    new_page_url = base_url + path
    page_data = Nokogiri::HTML(URI.open(new_page_url))
    page_data.css(".schedule-overview .item-list.schedule-item-list").each do |events|
      events.css(".item-list--item").each do |event|
        @event_params = {}
        event_params[:web_source] = web_source
        set_title_and_url(event)
        dup_event = find_event(event_params[:title])

        set_start_and_end_date(event_params[:title], event, event_params[:url], dup_event)
        set_picture_url(event)
        set_start_time_and_end_time_and_venue(event)
        set_event_venue(dup_event, event_params[:venue_name])

        event_params.delete(:venue_name)
        all_calendar_events << event_params
      end
    end 
  end

  def set_title_and_url(event)
    heading_note = event.css('.item-list--row-item-content h2.h3 a')
    event_params[:title] = heading_note.text
    event_params[:url] = heading_note.attribute('href').value
  end

  def set_picture_url(event)
    picture_path = event.css('.item-list--row-item-content picture img').attribute('src').value
    event_params[:picture_url] = base_url + picture_path
  end

  def set_start_time_and_end_time_and_venue(event)
    time = event.css('.is-headline-sub.is-secondary').first.text.squish.split('-')
    if time.present?
      time_and_venue_name = time[0].strip.split[0..7]
      start_time = time_and_venue_name.shift
      end_time, venue_name = time[1].present? ? time[1].strip.split[0..7] : [nil, time_and_venue_name.join(' ')]
    else
      time = event.css('.node.node--type-termin.node--view-mode-cardfinder .field__item p').text.squish.split("-")
      start_time = time[1].strip.split(' ')[1]
      end_time = time[2].strip[0..4]
      venue_name = 'Gorki Kiosk & Jurte'
    end
    end_time = if end_time.present?
      end_time
    end
    if event_params[:title] == 'Discover Berlin anew! The rally app - The Lialo App'
      byebug
    end
    if start_time.present?
      event_params[:start_time] = event_time(event_params[:start_date], start_time)
    end
    if end_time.present?
      event_params[:end_time] = event_time(event_params[:end_date] || event_params[:start_date], end_time)
    end
    event_params[:venue_name] = venue_name
  end

  def set_start_and_end_date(title, event, detail_page_url, dup_event)
    end_date = detail_page_url.split("/").last
    if has_digits?(end_date)
      event_params[:end_date] = DateTime.parse(end_date)
    end
    start_date = dup_event.presence ? dup_event.start_date : event_params[:end_date]
    event_params[:start_date] = has_digits?(start_date) ? start_date : nil
  end

  def set_event_venue(dup_event, venue_name)
    if dup_event.blank? && venue_name.present?
      event_params[:event_venue_attributes] = { name: venue_name }
    end
  end
end
