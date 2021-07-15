# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homepage requests' do
  describe 'Viewing the homepage' do
    it 'returns HTTP 200' do
      get('/')
      expect(response).to have_http_status(:ok)
    end
  end
end
