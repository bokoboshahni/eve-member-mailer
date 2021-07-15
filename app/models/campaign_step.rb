# frozen_string_literal: true

# ## Schema Information
#
# Table name: `campaign_steps`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`body`**               | `text`             |
# **`delay`**              | `integer`          |
# **`delivery_time`**      | `time`             |
# **`kind`**               | `text`             | `not null`
# **`position`**           | `integer`          | `not null`
# **`status`**             | `text`             | `not null`
# **`subject`**            | `text`             |
# **`validation_data`**    | `jsonb`            |
# **`validation_status`**  | `text`             |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`campaign_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_campaign_steps_on_campaign_id`:
#     * **`campaign_id`**
# * `index_unique_campaign_step_positions` (_unique_):
#     * **`campaign_id`**
#     * **`position`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`campaign_id => campaigns.id`**
#
class CampaignStep < ApplicationRecord
  has_paper_trail meta: { campaign_id: :campaign_id }

  belongs_to :campaign, inverse_of: :steps, touch: true
  belongs_to :sender, inverse_of: :steps

  has_many :deliveries, inverse_of: :campaign_step, dependent: :restrict_with_exception

  before_validation :generate_position, on: :create

  def delay_before
    campaign.steps.select(:delay, :position).where('position < ?', position).sum(:delay)
  end

  private

  def generate_position
    self.position = campaign.steps.select(&:persisted?).empty? ? 0 : campaign.steps.maximum(:position) + 1
  end
end
