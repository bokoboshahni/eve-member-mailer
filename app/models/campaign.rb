# frozen_string_literal: true

# ## Schema Information
#
# Table name: `campaigns`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`default_delivery_time`**  | `time`             |
# **`description`**            | `text`             |
# **`discarded_at`**           | `datetime`         |
# **`kind`**                   | `text`             | `not null`
# **`name`**                   | `text`             | `not null`
# **`qualifier`**              | `text`             | `not null`
# **`slug`**                   | `text`             | `not null`
# **`started_at`**             | `datetime`         |
# **`status`**                 | `text`             | `not null`
# **`status_data`**            | `jsonb`            |
# **`stopped_at`**             | `datetime`         |
# **`validation_data`**        | `jsonb`            |
# **`validation_status`**      | `text`             |
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`corporation_id`**         | `bigint`           | `not null`
# **`owner_id`**               | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_campaigns_on_corporation_id`:
#     * **`corporation_id`**
# * `index_campaigns_on_discarded_at`:
#     * **`discarded_at`**
# * `index_campaigns_on_kind`:
#     * **`kind`**
# * `index_campaigns_on_owner_id`:
#     * **`owner_id`**
# * `index_campaigns_on_status`:
#     * **`status`**
# * `index_unique_campaign_slugs` (_unique_):
#     * **`slug`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
# * `fk_rails_...`:
#     * **`owner_id => users.id`**
#
class Campaign < ApplicationRecord
  include Discard::Model
  include SlugConcern

  KINDS = {
    conditional: 'Conditional'
    # date: 'Date'
  }.freeze

  TRIGGER_QUANTIFIERS = {
    all: 'All',
    any: 'Any'
  }.freeze

  audited

  belongs_to :owner, class_name: 'User', inverse_of: :campaigns

  has_many :campaign_steps, inverse_of: :campaign, dependent: :restrict_with_exception
  has_many :deliveries, inverse_of: :campaign, dependent: :restrict_with_exception

  has_many :campaign_memberships, inverse_of: :campaign, dependent: :restrict_with_exception
  has_many :characters, through: :memberships, source: :character

  has_many :triggers, inverse_of: :campaign, dependent: :restrict_with_exception
  has_many :lists, through: :triggers, inverse_of: :campaigns

  validates :delivery_hour, presence: true,
                            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23 }
  validates :delivery_minute, presence: true,
                              numericality: {
                                only_integer: true,
                                greater_than_or_equal_to: 0,
                                less_than_or_equal_to: 59
                              }
  validates :trigger_quantifier, presence: true, inclusion: { in: TRIGGER_QUANTIFIERS.keys.map(&:to_s) }
  validates :kind, presence: true, inclusion: { in: KINDS.keys.map(&:to_s) }
  validates :name, presence: true
end
