# frozen_string_literal: true

# Controller for campaign triggers.
class CampaignTriggersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_campaign
  before_action :find_trigger, only: %i[edit update destroy]
  before_action -> { set_current(:campaigns) }

  def new
    @trigger = authorize(@campaign.triggers.build)
  end

  def create
    @trigger = authorize(@campaign.triggers.build(trigger_params))
    if @trigger.save
      flash[:success] = 'Campaign trigger created successfully. Discovering new members for campaign...'
      AddCampaignMembersJob.perform_later(@campaign.id)
      redirect_to campaign_path(@campaign)
    else
      render :new
    end
  end

  def edit; end

  def update
    if authorize(@trigger.update(trigger_params))
      flash[:success] = 'Campaign trigger updated successfully.'
      redirect_to campaign_path(@campaign)
    else
      render :edit
    end
  end

  def destroy
    authorize(@trigger.destroy)
    flash[:success] = 'Campaign trigger deleted successfully.'
    redirect_to campaign_path(@campaign)
  end

  private

  def trigger_params
    params.require(:campaign_trigger).permit(:date_attribute, :date_day, :date_month, :date_window, :date_year, :kind,
                                             :list_qualifier, :list_id)
  end

  def find_campaign
    @campaign = current_corporation.campaigns.find(params[:campaign_id])
  end

  def find_trigger
    @trigger = authorize(@campaign.triggers.find(params[:id]))
  end
end
