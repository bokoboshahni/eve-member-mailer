# frozen_string_literal: true

# Moves position of a campaign step up or down.
class RearrangeCampaignSteps
  def initialize(campaign, step, direction)
    @campaign = campaign
    @step = step
    @direction = direction.to_sym
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    steps = campaign.steps.select(:id, :position).order(:position).to_a.map(&:attributes)
    selected = steps.find { |c| c['id'] == step.id }
    idx = steps.index(selected)

    # Step is at the beginning and can't move up
    return if direction == :up && idx.zero?

    # Step is at the end and can't move down
    return if direction == :down && idx == steps.size - 1

    case direction
    when :up
      prev_idx = idx - 1
      steps[prev_idx, idx] = steps.values_at(idx, prev_idx)
    when :down
      next_idx = idx + 1
      steps[idx, next_idx] = steps.values_at(next_idx, idx)
    end

    campaign.steps.transaction do
      records = steps.each_with_object({}) { |c, h| h[c['id']] = { 'position' => steps.index(c) } }
      # Ugly kludge to not violate uniqueness constraint on the campaign ID/trigger ID index
      CampaignStep.update(records.keys, Array.new(records.count) { { 'position' => rand(0...1000) } })
      CampaignStep.update(records.keys, records.values)
    end
  end

  private

  attr_reader :campaign, :step, :direction
end
