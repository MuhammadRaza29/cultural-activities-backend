require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'Associations' do
    it { should belong_to(:category).optional }
    it { should have_one(:event_venue) }
  end
  
  it 'creates event' do
    expect { described_class.create! }.not_to raise_error
  end
end
