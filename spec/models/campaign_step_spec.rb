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
require 'rails_helper'

RSpec.describe CampaignStep, type: :model do
end
