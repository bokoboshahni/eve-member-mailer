# frozen_string_literal: true

# Controller for campaign memberships.
class CampaignMembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_campaign
  before_action :find_campaign_member
  before_action :find_deliveries
  before_action -> { set_current(:campaigns) }

  def show; end

  private

  def find_campaign
    @campaign = authorize(current_corporation.campaigns.find(params[:campaign_id]))
  end

  def find_campaign_member
    @campaign_member = authorize(@campaign.campaign_members.find(params[:id]))
  end

  def find_deliveries
    @deliveries = @campaign.deliveries.where(member_id: @campaign_member.member_id)
  end
end
