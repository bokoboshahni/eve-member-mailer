require 'rails_helper'

RSpec.describe Progression::ScheduleEvents, type: :service do
  subject(:service) { described_class.new(progression: progression) }

  let!(:progression) { FactoryBot.create(:progression) }
  let!(:series) { progression.series }
  let!(:steps) { FactoryBot.create_list(:evemail_series_step, 5, series: series) }

  it 'creates an event for each step in the series' do
    service.call

    expect(progression.events.pluck(:step_id)).to include(*steps.map(&:id) )
  end
end
