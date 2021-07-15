# frozen_string_literal: true

# Controller for deliveries.
class DeliveriesController < ApplicationController
  before_action :authenticate_user!
end
