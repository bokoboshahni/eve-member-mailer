# frozen_string_literal: true

# ## Schema Information
#
# Table name: `lists`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`description`**     | `text`             |
# **`discarded_at`**    | `datetime`         |
# **`kind`**            | `text`             | `not null`
# **`name`**            | `text`             | `not null`
# **`qualifier`**       | `text`             | `not null`
# **`slug`**            | `text`             | `not null`
# **`status`**          | `text`             | `not null`
# **`status_data`**     | `jsonb`            |
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`corporation_id`**  | `bigint`           | `not null`
# **`owner_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_lists_on_corporation_id`:
#     * **`corporation_id`**
# * `index_lists_on_discarded_at`:
#     * **`discarded_at`**
# * `index_lists_on_owner_id`:
#     * **`owner_id`**
# * `index_lists_on_status`:
#     * **`status`**
# * `index_unique_list_slug` (_unique_):
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

RSpec.describe List, type: :model do
end
