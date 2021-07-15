# frozen_string_literal: true

# Controller for list members.
class ListMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_list
  before_action -> { set_current(:lists) }

  def new
    authorize(ListMember, :new?)

    if @list.kind == 'manual'
      render :new
    else
      flash['error'] = 'Members cannot be manually added to an automated list.'
      redirect_to list_path(@list)
    end
  end

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
    authorize(ListMember, :create?)
    if @list.kind == 'manual'
      add_members = AddListMembersByName.new(@list, list_member_params[:names])
      success = add_members.call
      if success && add_members.successes.empty?
        queue_campaign_sync
        flash[:success] = 'No member(s) added to the list.'
        redirect_to list_path(@list)
      elsif success
        queue_campaign_sync
        flash[:success] = "Successfully added #{add_members.successes.count} member(s) to the list."
        redirect_to list_path(@list)
      elsif !success && add_members.successes.count.positive?
        queue_campaign_sync
        flash[:warning] = "Successfully added #{add_members.successes.count} member(s) to the list. " \
                        "Error adding #{add_members.failures.count} member(s). " \
                        'The following name(s) are not members in the corporation:'
        flash[:list] = add_members.failures
        redirect_to list_path(@list)
      else
        flash[:error] =
          "Error adding #{add_members.failures.count} member(s) to the list. " \
          'None of the name(s) provided are members in the corporation.'
        render :new
      end
    else
      flash[:error] = 'Members cannot be manually added to an automated list.'
      redirect_to list_path(@list)
    end
  end

  def destroy
    @list_member = authorize(@list.members.find(params[:id]))
    if list.kind == 'manual'
      @list_member.destroy
      flash[:success] = 'Member removed from list successfully.'
      redirect_to list_path(@list)
    else
      flash['error'] = 'Members cannot be manually removed from an automated list.'
    end
  end

  private

  def queue_campaign_sync
    @list.campaigns.each do |campaign|
      AddCampaignMembersJob.perform_later(campaign.id)
    end
  end

  def list_member_params
    params.permit(:names)
  end

  def find_list
    @list = current_corporation.lists.find(params[:list_id])
  end
end
