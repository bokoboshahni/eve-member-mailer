# frozen_string_literal: true

# Moves position of a list condition up or down.
class RearrangeListConditions < ApplicationService
  def initialize(list, condition, direction)
    super

    @list = list
    @condition = condition
    @direction = direction.to_sym
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    conditions = list.conditions.select(:id, :position).order(:position).to_a.map(&:attributes)
    selected = conditions.find { |c| c['id'] == condition.id }
    idx = conditions.index(selected)

    # Condition is at the beginning and can't move up
    return if direction == :up && idx.zero?

    # Condition is at the end and can't move down
    return if direction == :down && idx == conditions.size - 1

    case direction
    when :up
      prev_idx = idx - 1
      conditions[prev_idx, idx] = conditions.values_at(idx, prev_idx)
    when :down
      next_idx = idx + 1
      conditions[idx, next_idx] = conditions.values_at(next_idx, idx)
    end

    list.conditions.transaction do
      records = conditions.each_with_object({}) { |c, h| h[c['id']] = { 'position' => conditions.index(c) } }
      # Ugly kludge to not violate uniqueness constraint on the list ID/condition ID index
      ListCondition.update(records.keys, Array.new(records.count) { { 'position' => rand(0...1000) } })
      ListCondition.update(records.keys, records.values)
    end
  end

  private

  attr_reader :list, :condition, :direction
end
