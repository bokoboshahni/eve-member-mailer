# frozen_string_literal: true

# ## Schema Information
#
# Table name: `progression_events`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`completed_at`**    | `datetime`         |
# **`position`**        | `integer`          | `not null`
# **`scheduled_for`**   | `datetime`         |
# **`status`**          | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`delivery_id`**     | `bigint`           |
# **`progression_id`**  | `bigint`           | `not null`
# **`step_id`**         | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_progression_events_on_delivery_id`:
#     * **`delivery_id`**
# * `index_progression_events_on_progression_id`:
#     * **`progression_id`**
# * `index_progression_events_on_status`:
#     * **`status`**
# * `index_progression_events_on_step_id`:
#     * **`step_id`**
# * `index_unique_progression_events` (_unique_):
#     * **`progression_id`**
#     * **`step_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`delivery_id => deliveries.id`**
# * `fk_rails_...`:
#     * **`step_id => series_steps.id`**
#
class ProgressionEvent < ApplicationRecord
  belongs_to :delivery, inverse_of: :progression_event, optional: true
  belongs_to :progression, inverse_of: :steps
  belongs_to :step, class_name: 'SeriesStep', inverse_of: :events

  has_one :character, through: :progression
  has_one :series, through: :progression

  acts_as_list scope: :progression_id

  validates :status, presence: true
end
