# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authorization::Create, type: :service, vcr: true do
  subject(:service) { described_class.new(auth_info, user) }

  let(:user) { FactoryBot.create(:user) }

  let(:uid) { '2113024536' }
  let(:expires_at) { 1.hour.from_now.change(usec: 0) }
  let(:token) { 'some-access-token' }
  let(:refresh_token) { 'some-refresh-token' }
  let(:auth_info) do
    OmniAuth::AuthHash.new(
      uid: uid,
      credentials: {
        token: token,
        refresh_token: refresh_token,
        expires_at: expires_at.to_i
      }
    )
  end

  context 'when the character is available' do
    before do
      service.call
    end

    let(:user_character) { user.user_characters.find_by(character_id: uid) }
    let(:character) { user_character.character }
    let(:authorization) { character.authorization }

    it 'associates the character with the user' do
      expect(user_character).not_to be_nil
    end

    it 'creates an authorization for the character' do
      expect(authorization).to be_persisted
    end
  end

  context 'when the character is already associated with the user' do
    before do
      user.main_character = character
    end

    let(:character) { Character::SyncFromESI.new(uid).call }

    it 'updates the authorization' do
      authorization = FactoryBot.create(:authorization, character: character)
      expect { service.call }.to(change { authorization.reload.updated_at })
    end
  end

  context 'when the character is associated with another user' do
    it 'raises an error' do
      another_user = FactoryBot.create(:user)
      character = Character::SyncFromESI.new(uid).call
      another_user.main_character = character

      expect { service.call }.to raise_error(Authorization::Create::AlreadyInUseError)
    end
  end
end
