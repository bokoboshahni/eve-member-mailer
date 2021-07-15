# frozen_string_literal: true

# Controller for campaign deliveries.
class CampaignDeliveriesController < ApplicationController
  before_action :authenticate_user!
  before_action -> { set_current(:campaigns) }
end
