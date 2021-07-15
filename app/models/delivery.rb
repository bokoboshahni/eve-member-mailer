# frozen_string_literal: true

# ## Schema Information
#
# Table name: `deliveries`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`attempted_at`**      | `datetime`         |
# **`body`**              | `text`             |
# **`delivered_at`**      | `datetime`         |
# **`failed_at`**         | `datetime`         |
# **`kind`**              | `text`             | `not null`
# **`queued_at`**         | `datetime`         |
# **`scheduled_for`**     | `datetime`         |
# **`status`**            | `text`             | `not null`
# **`status_data`**       | `jsonb`            |
# **`subject`**           | `text`             |
# **`uuid`**              | `uuid`             | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`alliance_id`**       | `bigint`           |
# **`authorization_id`**  | `bigint`           |
# **`broadcast_id`**      | `bigint`           |
# **`campaign_step_id`**  | `bigint`           |
# **`character_id`**      | `bigint`           |
# **`corporation_id`**    | `bigint`           |
# **`evemail_id`**        | `integer`          |
# **`template_id`**       | `bigint`           |
#
# ### Indexes
#
# * `index_deliveries_on_alliance_id`:
#     * **`alliance_id`**
# * `index_deliveries_on_authorization_id`:
#     * **`authorization_id`**
# * `index_deliveries_on_broadcast_id`:
#     * **`broadcast_id`**
# * `index_deliveries_on_campaign_step_id`:
#     * **`campaign_step_id`**
# * `index_deliveries_on_character_id`:
#     * **`character_id`**
# * `index_deliveries_on_corporation_id`:
#     * **`corporation_id`**
# * `index_deliveries_on_status`:
#     * **`status`**
# * `index_deliveries_on_template_id`:
#     * **`template_id`**
# * `index_unique_delivery_broadcast_alliances` (_unique_):
#     * **`broadcast_id`**
#     * **`alliance_id`**
# * `index_unique_delivery_broadcast_characters` (_unique_):
#     * **`broadcast_id`**
#     * **`character_id`**
# * `index_unique_delivery_broadcast_corporations` (_unique_):
#     * **`broadcast_id`**
#     * **`corporation_id`**
# * `index_unique_delivery_campaign_steps` (_unique_):
#     * **`campaign_step_id`**
#     * **`character_id`**
# * `index_unique_delivery_uuid` (_unique_):
#     * **`uuid`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
# * `fk_rails_...`:
#     * **`authorization_id => authorizations.id`**
# * `fk_rails_...`:
#     * **`broadcast_id => broadcasts.id`**
# * `fk_rails_...`:
#     * **`campaign_step_id => campaign_steps.id`**
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
# * `fk_rails_...`:
#     * **`template_id => templates.id`**
#
class Delivery < ApplicationRecord
  KINDS = {
    broadcast: 'Broadcast',
    campaign: 'Campaign',
    test: 'Test'
  }.freeze

  belongs_to :sender, inverse_of: :deliveries

  belongs_to :alliance, inverse_of: :eve_deliveries_received, optional: true
  belongs_to :broadcast, inverse_of: :eve_deliveries, optional: true
  belongs_to :character, inverse_of: :eve_deliveries_received, optional: true
  belongs_to :corporation, inverse_of: :eve_deliveries_received, optional: true
  belongs_to :campaign_step, inverse_of: :eve_deliveries, optional: true
  belongs_to :template, inverse_of: :eve_deliveries, optional: true

  has_one :campaign, through: :campaign_step

  scope :delivered, -> { where(status: 'delivered') }
  scope :scheduled, -> { where(status: 'scheduled') }

  validates :kind, presence: true, inclusion: { in: KINDS.keys.map(&:to_s) }

  def deliver!
    SendScheduledDelivery.new(self).call
  end

  def delivered?
    status == 'delivered'
  end

  def scheduled?
    status == 'scheduled'
  end

  def a_broadcast?
    kind == 'broadcast'
  end

  def a_campaign?
    kind == 'campaign'
  end

  def a_test?
    kind == 'test'
  end
end
