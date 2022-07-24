class CalendarEvents::Visitberlin < CalendarEvents::Base
  def call
    fetch_and_parse_data
    save_or_update_calendar_events
  end

  private

  def fetch_and_parse_data
    @response = Nokogiri::HTML(URI.open(url))
    (0...2).each do |page_no|
    #(0...total_pages).each do |page_no|
      new_page_url = "#{base_url}/en/event-calendar-berlin?page=#{page_no}"
      page_data = Nokogiri::HTML(URI.open(new_page_url))
      page_data.css(".site-main .l-list .l-list__item").each do |event|
        @event_params = {}
        event_params[:web_source] = web_source
        set_title(event)
        set_category(event)
        set_description(event)
        set_start_and_end_date(event)
        set_start_and_end_time(event)
        set_detail_page_and_picture_url(event)
        
        dup_event = find_event(event_params[:title])
        venue_name = event.css(".teaser-search__location.me .nopr").text
        if dup_event.blank? && venue_name.present?
          event_params[:event_venue_attributes] = { name: venue_name }
        end
        all_calendar_events << event_params
      end
    end
  end

  def set_start_and_end_date(event)
    date = event.css(".teaser-search__header-content .teaser-search__date time")
    event_params[:start_date] = date[0].text
    event_params[:end_date] = date[1].present? ? date[1].text : event_params[:start_date]
  end

  def set_start_and_end_time(event)
    time = event.css(".teaser-search__time.me .me__content").text
    event_params[:start_time], event_params[:end_time] = time.present? ? time.split("–").map(&:strip) : [nil, nil]
  end

  def set_detail_page_and_picture_url(event)
    path = event.css(".teaser-search.teaser-search--event").attribute("about").value
    event_params[:url] = base_url + path
    picture_path = event.css(".teaser-search__header.teaser-search__header--has-image picture img").attribute("src").value
    event_params[:picture_url] = base_url + picture_path
  end

  def set_category(event)
    category_name = event.css(".category-label").text
    category = Category.find_or_create_by(name: category_name)
    event_params[:category_id] = category.id
  end

  def set_title(event)
    event_params[:title] = event.css("h2 .heading-highlight__inner").text
  end

  def set_description(event)
    event_params[:description] = event.css(".teaser-search__text div").text
  end

  def total_pages
    footer = response.css('.view-footer .pager__item--last a')
    footer.first.attribute("href").value.split("=")[1]
  end
end
