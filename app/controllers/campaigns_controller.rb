# frozen_string_literal: true

# Controller for campaigns.
class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_campaign, only: %i[show edit update destroy]

  def index
    authorize(Campaign)
    @pagy, @campaigns = pagy(current_corporation.campaigns.kept.order(:name))
  end

  def new
    @campaign = authorize(Campaign.new)
  end

  def create
    @campaign = authorize(current_corporation.campaigns.build(campaign_params.merge(trigger_quantifier: 'any',
                                                                                    status: 'active')))
    if @campaign.save
      flash[:success] = 'Campaign created successfully.'
      redirect_to campaign_path(@campaign)
    else
      render :new
    end
  end

  def show
    @pagy, @campaign_members = pagy(@campaign.campaign_members)
    @deliveries = @campaign.deliveries.where(member_id: @campaign_members.map(&:member_id))
  end

  def edit; end

  def update
    if @campaign.update(campaign_params)
      flash[:success] = 'Campaign updated successfully.'
      redirect_to campaign_path(@campaign)
    else
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    flash[:success] = 'Campaign deleted successfully.'
    redirect_to campaigns_path
  end

  def discard
    @campaign.discard
    flash[:success] = 'Campaign moved to trash.'
    redirect_to campaigns_path
  end

  private

  def campaign_params
    params.require(:campaign).permit(:name, :kind, :description, :trigger_quantifier, :delivery_hour, :delivery_minute)
  end

  def find_campaign
    @campaign = authorize(current_corporation.campaigns.find(params[:id]))
  end
end
