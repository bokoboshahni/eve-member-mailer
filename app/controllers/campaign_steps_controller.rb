# frozen_string_literal: true

# Controller for campaign steps.
class CampaignStepsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_campaign
  before_action :find_step, except: %i[new create]
  before_action -> { set_current(:campaigns) }

  def index
    authorize(Campaign)
    @steps = @campaign.steps.order(:position)
  end

  def new
    @step = authorize(@campaign.steps.build)
  end

  def create
    @step = @campaign.steps.build(step_params)
    if @step.save
      ScheduleCampaignDeliveriesJob.perform_later(@campaign.id)
      flash[:success] = 'Campaign step created successfully.'
      redirect_to campaign_path(@campaign)
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if params[:campaign_step] && %w[down up].include?(params[:campaign_step][:direction])
      authorize(@step, :update?)
      RearrangeCampaignSteps.new(@campaign, @step, params[:campaign_step][:direction]).call
      ScheduleCampaignDeliveriesJob.perform_later(@campaign.id)
      flash[:success] = 'Campaign steps reordered successfully.'
      redirect_to campaign_path(@campaign)
    elsif authorize(@step.update(step_params))
      ScheduleCampaignDeliveriesJob.perform_later(@campaign.id)
      flash[:success] = 'Campaign step updated successfully.'
      redirect_to campaign_path(@campaign)
    else
      render :edit
    end
  end

  def destroy
    authorize(@step.destroy)
    flash[:success] = 'Campaign step deleted successfully.'
    redirect_to campaign_path(@campaign)
  end

  private

  def step_params
    params.require(:campaign_step).permit(:delay_days, :kind, :template_id, :user_id, :direction)
  end

  def find_campaign
    @campaign = authorize(current_corporation.campaigns.find(params[:campaign_id]))
  end

  def find_step
    @step = authorize(@campaign.steps.find(params[:id]))
  end
end
