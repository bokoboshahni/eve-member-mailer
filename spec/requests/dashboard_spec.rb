# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :request, vcr: true do
  let(:character) { SyncESICharacter.new('96224792').call }
  let(:user) { User.create! }

  before do
    user.main_character = character
    sign_in(user)
  end

  describe 'GET #index' do
    before { get dashboard_path }

    it 'is successful' do
      expect(response).to have_http_status(:ok)
    end
  end
end
