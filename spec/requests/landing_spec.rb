# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Landings', type: :request do
  describe 'GET #index', vcr: true do
    context 'when signed in' do
      let(:character) { SyncESICharacter.new('96224792').call }
      let(:user) { User.create! }

      before do
        user.main_character = character
        sign_in(user)
        get root_path
      end

      it 'is redirects to the dashboard' do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context 'when signed out' do
      before { get root_path }

      it 'is successful' do
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
