require 'rails_helper'

RSpec.describe CulturalActivitiesBackend::V1::Events do
  describe 'GET api/v1/events' do
    it 'returns all events' do
      get '/api/v1/events'
      expect(response.status).to eq(200)
    end
  end
end
