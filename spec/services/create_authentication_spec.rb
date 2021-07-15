# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAuthentication, type: :service, vcr: true do
  subject(:service) { described_class.new(auth_info) }

  let(:uid) { '2113024536' }
  let(:auth_info) { OmniAuth::AuthHash.new(uid: uid) }

  context 'when character alliance is not allowed to log in' do
    before do
      allow(Rails.application.config.x.emm).to receive(:allowed_alliance_ids).and_return([])
    end

    let(:uid) { '96224792' }

    it 'raises an error' do
      expect { service.call }.to raise_error(CreateAuthentication::NotAllowedError)
    end
  end

  context 'when the character is associated with an existing user' do
    before do
      allow(Rails.application.config.x.emm).to receive(:allowed_alliance_ids).and_return(%w[99003214])
    end

    it 'returns the user' do
      user = FactoryBot.create(:user)
      character = SyncESICharacter.new(uid).call
      user.main_character = character

      expect(service.call.id).to eq(user.id)
    end
  end

  context 'when the character is not associated with an existing user' do
    before do
      allow(Rails.application.config.x.emm).to receive(:allowed_alliance_ids).and_return(%w[99003214])
    end

    let(:user_character) { UserCharacter.find_by!(character_id: uid, main: true) }

    it 'sets the character as the main character for the new user' do
      service.call
      expect(UserCharacter.find_by!(character_id: uid, main: true)).to be_persisted
    end

    it 'returns the new user' do
      expect(service.call).to be_a(User)
    end
  end
end
