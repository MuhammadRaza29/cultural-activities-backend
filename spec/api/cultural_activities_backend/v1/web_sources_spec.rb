require 'rails_helper'

RSpec.describe CulturalActivitiesBackend::V1::WebSources do
  describe 'GET api/v1/events' do
    it 'returns all web sources' do
      get '/api/v1/web_sources'
      expect(response.status).to eq(200)
    end
  end
end
