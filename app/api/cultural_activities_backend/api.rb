module CulturalActivitiesBackend
  class API < Grape::API
    format :json
    version 'v1', using: :path
    prefix :api

    mount V1::Events
  end
end