module CulturalActivitiesBackend
  module V1
    class WebSources < API
      resources :web_sources do
        desc 'Fetch All Web Sources'
        get do
          WEB_SOURCES
        end
      end
    end
  end
end
