# frozen_string_literal: true

# Schedules any unscheduled deliveries needed for a member of a campaign.
class ScheduleCampaignMemberDeliveries < ApplicationService
  def initialize(campaign, member)
    super

    @campaign = campaign
    @member = member
  end

  # TODO: Refactor this method.
  def call # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    steps.each_with_object([]) do |step, deliveries|
      next if step.kind == 'delay'

      existing_delivery = Delivery.find_by(campaign_id: campaign.id, member_id: member.id, step_id: step.id)
      next if existing_delivery && existing_delivery.status == 'delivered'

      delay = step.delay_before
      date = campaign_member.created_at.to_date
      hour = step.delivery_hour || campaign.delivery_hour
      minute = step.delivery_minute || campaign.delivery_minute

      # Schedule delivery for the time the member entered the campaign plus accumulated delay from prior steps
      schedule_for = Time.utc(date.year, date.month, date.day, hour, minute, 0) + delay.days

      # Deliver the next day if desired delivery HH:MM has already passed
      schedule_for += 1.day if schedule_for < Time.zone.now

      if existing_delivery && existing_delivery.status == 'scheduled' && existing_delivery.scheduled_at != schedule_for
        Rails.logger.info("Updating schedule for delivery #{existing_delivery.id} to #{schedule_for}")
        delivery.update!(scheduled_at: schedule_for, user: step.user)
        next
      end

      # Only schedule delivery if not already scheduled
      delivery = Delivery.create!(
        campaign: campaign,
        member: member,
        step: step,
        kind: 'campaign',
        scheduled_at: schedule_for,
        status: 'scheduled',
        template: step.template,
        user: step.user
      )

      deliveries << delivery
    end
  end

  private

  attr_reader :campaign, :member

  def steps
    @steps ||= campaign.steps.order(:position)
  end

  def campaign_member
    @campaign_member ||= campaign.campaign_members.find_by(member_id: member.id)
  end
end
