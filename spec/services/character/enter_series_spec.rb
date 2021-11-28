require 'rails_helper'

RSpec.describe Character::EnterSeries, type: :service do
  subject(:service) { described_class.new(character: character, series: series) }

  let(:user) { FactoryBot.create(:user) }
  let(:corporation) { FactoryBot.create(:corporation) }
  let(:series) { FactoryBot.create(:series, corporation: corporation) }
  let(:character) { FactoryBot.create(:character, corporation: corporation) }

  it 'creates a progression for the character' do
    service.call

    expect(character.progressions.exists?(series: series)).to be_truthy
  end

  it 'does not create a new progression if one already exists' do
    FactoryBot.create(:progression, series: series, character: character)
    service.call

    expect(character.progressions.where(series: series).count).to eq(1)
  end
end
