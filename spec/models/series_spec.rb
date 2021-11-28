# frozen_string_literal: true

# ## Schema Information
#
# Table name: `series`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`default_delivery_time`**  | `time`             |
# **`description`**            | `text`             |
# **`discarded_at`**           | `datetime`         |
# **`name`**                   | `text`             | `not null`
# **`started_at`**             | `datetime`         |
# **`status`**                 | `text`             | `not null`
# **`stopped_at`**             | `datetime`         |
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`corporation_id`**         | `bigint`           | `not null`
# **`owner_id`**               | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_series_on_corporation_id`:
#     * **`corporation_id`**
# * `index_series_on_discarded_at`:
#     * **`discarded_at`**
# * `index_series_on_owner_id`:
#     * **`owner_id`**
# * `index_series_on_status`:
#     * **`status`**
# * `index_unique_series_names` (_unique_):
#     * **`corporation_id`**
#     * **`name`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
# * `fk_rails_...`:
#     * **`owner_id => users.id`**
#
require 'rails_helper'

RSpec.describe Series, type: :model do
end