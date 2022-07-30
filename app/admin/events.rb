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
end
