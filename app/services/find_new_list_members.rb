# frozen_string_literal: true

class FindNewListMembers < ApplicationService
  def initialize(list)
    super

    @list = list
  end

  def call
    return [] unless list.conditions.any?

    # For members not in list, check list conditions to see whether to add them
    members_not_in_list.each_with_object([]) do |member, new_members|
      # Evaluate each condition in order
      results = conditions.map do |condition|
        # Only conditions of "'Attribute' 'start_date' 'is_a_timestamp_after'
        # 'a relative date', ### days, 'ago'" are supported.
        eval_condition(condition, member)
      end

      # We only support one condition right now.
      new_members << member if results.all? { |result| result }
    end
  end

  private

  attr_reader :list

  def eval_condition(condition, member)
    case condition.subject
    when 'character_name'
      eval_attribute_string_condition(condition, member.name)
    when 'start_date'
      eval_attribute_timestamp_condition(condition, member.started_on)
    end
  end

  def eval_attribute_string_condition(condition, value) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
    condition_name = condition.condition
    condition_value = condition.value
    case condition_name
    when 'is_equal_to'
      value == condition_value
    when 'is_not_equal_to'
      value != condition_value
    when 'contains'
      value.include?(condition_value)
    when 'does_not_contain'
      value.exclude?(condition_value)
    when 'starts_with'
      value.start_with?(condition_value)
    when 'does not start with'
      !value.start_with?(condition_value)
    when 'ends_with'
      value.end_with?(condition_value)
    when 'does not end with'
      !value.end_with?(condition_value)
    end
  end

  def eval_attribute_timestamp_condition(condition, value) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    return true if condition.condition == 'is_a_timestamp'

    condition_value =
      case condition.value_prefix
      when 'relative_date'
        condition.value.to_i.days.send(condition.value_suffix)
      when 'specific_date'
        condition.value
      end

    condition_value_from =
      case condition.value_prefix
      when 'relative_date'
        condition.value_from.to_i.days.send(condition.value_suffix)
      when 'specific_date'
        condition.value
      end

    condition_value_to =
      case condition.value_prefix
      when 'relative_date'
        condition.value_to.to_i.days.send(condition.value_suffix)
      when 'specific_date'
        condition.value
      end

    condition_value = condition_value.to_date
    case condition.condition
    when 'is_a_timestamp_before'
      value < condition_value
    when 'is_a_timestamp_after'
      value > condition_value
    when 'is_a_timestamp_between'
      value >= condition_value_from.to_date && value <= condition_value_to.to_date
    end
  end

  def conditions
    @conditions ||= list.conditions.where(parent_id: nil).order(:position)
  end

  def corporation_members
    @corporation_members ||= list.corporation.characters.kept
  end

  def current_members
    @current_members ||= list.members
  end

  def members_not_in_list
    @members_not_in_list ||= Character.find(corporation_members.map(&:id) - current_members.map(&:id))
  end
end
