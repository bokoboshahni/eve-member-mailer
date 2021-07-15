# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Settings', type: :request, vcr: true do
  let(:character) { SyncESICharacter.new('96224792').call }
  let(:user) { User.create! }

  before do
    user.main_character = character
    sign_in(user)
  end

  describe 'GET #show' do
    before { get settings_path }

    it 'is successful' do
      expect(response).to have_http_status(:ok)
    end
  end
end
