# frozen_string_literal: true

# ## Schema Information
#
# Table name: `journey_steps`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`paused_at`**         | `datetime`         |
# **`scheduled_for`**     | `datetime`         |
# **`started_at`**        | `datetime`         |
# **`status`**            | `text`             | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`campaign_step_id`**  | `bigint`           | `not null`
# **`delivery_id`**       | `bigint`           |
# **`journey_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_journey_steps_on_campaign_step_id`:
#     * **`campaign_step_id`**
# * `index_journey_steps_on_delivery_id`:
#     * **`delivery_id`**
# * `index_journey_steps_on_journey_id`:
#     * **`journey_id`**
# * `index_unique_journey_campaign_steps` (_unique_):
#     * **`journey_id`**
#     * **`campaign_step_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`campaign_step_id => campaign_steps.id`**
# * `fk_rails_...`:
#     * **`delivery_id => deliveries.id`**
# * `fk_rails_...`:
#     * **`journey_id => journeys.id`**
#
FactoryBot.define do
  factory :journey_step do
  end
end
