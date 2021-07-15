# frozen_string_literal: true

# ## Schema Information
#
# Table name: `list_conditions`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`ancestry`**        | `text`             |
# **`condition`**       | `text`             |
# **`discarded_at`**    | `datetime`         |
# **`kind`**            | `text`             | `not null`
# **`operator`**        | `text`             |
# **`position`**        | `integer`          | `not null`
# **`qualifier`**       | `text`             |
# **`subject`**         | `text`             |
# **`value`**           | `text`             |
# **`value_from`**      | `text`             |
# **`value_prefix`**    | `text`             |
# **`value_suffix`**    | `text`             |
# **`value_to`**        | `text`             |
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`alliance_id`**     | `bigint`           |
# **`corporation_id`**  | `bigint`           |
# **`list_id`**         | `bigint`           |
#
# ### Indexes
#
# * `index_list_conditions_on_alliance_id`:
#     * **`alliance_id`**
# * `index_list_conditions_on_ancestry`:
#     * **`ancestry`**
# * `index_list_conditions_on_corporation_id`:
#     * **`corporation_id`**
# * `index_list_conditions_on_discarded_at`:
#     * **`discarded_at`**
# * `index_list_conditions_on_list_id`:
#     * **`list_id`**
# * `index_unique_list_condition_positions` (_unique_):
#     * **`list_id`**
#     * **`ancestry`**
#     * **`position`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
# * `fk_rails_...`:
#     * **`list_id => lists.id`**
#
class ListCondition < ApplicationRecord
  SUBJECTS = {
    character_name: 'character name',
    start_date: 'start date'
  }.freeze

  KINDS = {
    attribute: 'Attribute'
  }.freeze

  CONDITIONS = {
    is_equal_to: 'is equal to',
    is_not_equal_to: 'is not equal to',
    # is_greater_than: 'is greater than',
    # is_less_than: 'is less than',
    # is_between: 'is between',
    # exists: 'exists',
    # does_not_exist: 'does not exist',
    contains: 'contains',
    does_not_contain: 'does not contain',
    starts_with: 'starts with',
    does_not_start_with: 'does not start with',
    ends_with: 'ends with',
    does_not_end_with: 'does not end with',
    is_a_timestamp: 'is a timestamp',
    is_a_timestamp_before: 'is a timestamp before',
    is_a_timestamp_after: 'is a timestamp after',
    is_a_timestamp_between: 'is a timestamp between'
  }.freeze

  QUANTIFIERS = {
    all: 'All',
    any: 'Any'
  }.freeze

  VALUE_PREFIXES = {
    relative_date: 'a relative date',
    specific_date: 'a specific date'
  }.freeze

  VALUE_SUFFIXES = {
    ago: 'ago',
    from_now: 'from now'
  }.freeze

  DATE_SUBJECTS = %w[start_date].freeze

  STRING_SUBJECTS = %w[character_name].freeze

  NEEDS_PREFIX = %w[start_date].freeze

  NEEDS_SUFFIX = %w[start_date].freeze

  has_paper_trail meta: { list_id: :list_id }

  belongs_to :list, inverse_of: :list_conditions

  belongs_to :alliance, inverse_of: :list_conditions, optional: true

  validates :kind, presence: true, inclusion: { in: KINDS.keys.map(&:to_s) }
  validates :quantifier, inclusion: { in: QUANTIFIERS.keys.map(&:to_s) }, allow_blank: true
  validates :subject, inclusion: { in: SUBJECTS.keys.map(&:to_s) }, allow_blank: true
  validates :value, presence: { if: -> { condition != 'is_a_timestamp' } },
                    timeliness: {
                      if: lambda {
                        DATE_SUBJECTS.include?(subject) &&
                          value_prefix == 'specific_date' &&
                          condition != 'is_a_timestamp'
                      },
                      type: :date, message: 'must be a specific date (e.g. 2021-04-20)'
                    },
                    numericality: {
                      greater_than: 0,
                      if: lambda {
                        DATE_SUBJECTS.include?(subject) &&
                          value_prefix == 'relative_date' &&
                          condition != 'is_a_timestamp'
                      },
                      message: 'must be a number of days'
                    },
                    format: { with: /\A[a-zA-Z0-9\-' ]+\z/ }, allow_blank: true
  validates :value_prefix,
            presence: {
              if: -> { NEEDS_PREFIX.include?(subject) }
            },
            inclusion: { in: VALUE_PREFIXES.keys.map(&:to_s) },
            allow_blank: true
  validates :value_suffix,
            presence: {
              if: -> { NEEDS_SUFFIX.include?(subject) }
            },
            inclusion: { in: VALUE_SUFFIXES.keys.map(&:to_s) },
            allow_blank: true

  before_validation :generate_position, on: :create

  def value
    raw = self[:value]
    if subject == 'character_name'
      raw.strip
    elsif subject == 'start_date' && value_prefix == 'specific_date'
      Date.parse(raw)
    elsif subject == 'start_date' && value_prefix == 'relative_date'
      raw.to_i
    end
  end

  private

  def generate_position
    self.position = list.conditions.select(&:persisted?).empty? ? 0 : list.conditions.maximum(:position) + 1
  end
end
