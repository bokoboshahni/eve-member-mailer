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
require 'rails_helper'

RSpec.describe Campaign, type: :model do
end
