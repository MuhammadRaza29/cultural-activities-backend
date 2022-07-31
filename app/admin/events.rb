ActiveAdmin.register Event do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title,
                :description,
                :web_source,
                :url,
                :picture_url,
                :status,
                :start_date,
                :end_date,
                :start_time,
                :end_time,
                :category_id,
                event_venue_attributes: %i[
                  id
                  name
                  _destroy
                ]
  index do
    id_column
    column :title
    column :description do |event|
      div event.description
    end
    column :web_source
    column :picture_url do |event|
      link_to event.picture_url, target: '_blank' do
        image_tag event.picture_url, width: '100%'
      end
    end
    column :status do |event|
      event.status.titleize
    end
    column :start_date
    column :end_date
    column :start_time
    column :end_time
    column :category_id do |event|
      event.category_name
    end
    column :event_venue do |event|
      event.event_venue_name
    end
    column :created_at
    column :updated_at
  end
end
