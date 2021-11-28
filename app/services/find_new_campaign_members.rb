# frozen_string_literal: true

class FindNewCampaignMembers < ApplicationService
  def initialize(campaign)
    super

    @campaign = campaign
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return [] unless campaign.triggers.any?

    case campaign.kind
    when 'conditional'
      all_new_members = lists.each_with_object([]) do |list, new_members|
        list_member_ids = list.members.map(&:id)
        current_member_ids = current_members.map(&:id)
        new_members << (list_member_ids - current_member_ids)
      end
      Member.find(all_new_members.flatten.uniq)
    when 'date'
      # Not supported yet.
    end
  end

  private

  attr_reader :campaign

  def lists
    @lists ||= campaign.lists
  end

  def current_members
    @current_members ||= campaign.members
  end

  def current_member_ids
    @current_member_ids ||= current_members.map(&:id)
  end
end
