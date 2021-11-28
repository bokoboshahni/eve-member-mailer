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
require 'rails_helper'

RSpec.describe ProgressionEvent, type: :model do
end
