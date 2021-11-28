# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Series::DiscoverSubscribers, type: :service do
  subject(:service) { described_class.new(series: series, newer_than: newer_than) }

  let(:user) { FactoryBot.create(:user) }
  let(:corporation) { FactoryBot.create(:corporation) }
  let(:series) { FactoryBot.create(:series, corporation: corporation) }
  let(:newer_than) { nil }

  it 'returns characters who are not already subscribed' do
    characters = FactoryBot.create_list(:character, 5, corporation: corporation)
    results = service.call

    expect(results).to include(*characters.map(&:id))
  end

  context 'with existing subscriptions' do
    let!(:subscribed_characters) { FactoryBot.create_list(:character, 5, corporation: corporation) }
    let!(:new_characters) { FactoryBot.create_list(:character, 5, corporation: corporation) }

    before do
      subscribed_characters.each { |c| series.subscriptions.create!(character: c, status: 'active') }
    end

    it 'returns characters who are not already subscribed' do
      expect(service.call).to include(*new_characters.map(&:id))
    end

    it 'does not return characters who are already subscribed' do
      expect(service.call).not_to include(*subscribed_characters.map(&:id))
    end
  end

  context 'with a newer than date' do
    let!(:older_characters) do
      FactoryBot.create_list(
        :character, 5, corporation: corporation,
        corporation_start_date: Faker::Date.between(from: 1.year.ago, to: 10.days.ago)
      )
    end

    let!(:newer_characters) do
      FactoryBot.create_list(
        :character, 5, corporation: corporation,
        corporation_start_date: Faker::Date.between(from: 10.days.ago + 1.second, to: Date.today)
      )
    end

    let(:newer_than) { 10.days.ago }

    it 'returns characters who have a corporation start date newer than the one specified' do
      expect(service.call).to include(*newer_characters.map(&:id))
    end

    it 'does not return characters who have a corporation start date older than the one specified' do
      expect(service.call).not_to include(*older_characters.map(&:id))
    end
  end
end
