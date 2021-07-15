# frozen_string_literal: true

# ## Schema Information
#
# Table name: `broadcasts`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`audience`**           | `text`             | `not null`
# **`body`**               | `text`             |
# **`discarded_at`**       | `datetime`         |
# **`name`**               | `text`             | `not null`
# **`scheduled_for`**      | `datetime`         |
# **`slug`**               | `text`             | `not null`
# **`status`**             | `text`             | `not null`
# **`status_data`**        | `jsonb`            |
# **`subject`**            | `text`             |
# **`validation_data`**    | `jsonb`            |
# **`validation_status`**  | `text`             |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`alliance_id`**        | `bigint`           |
# **`corporation_id`**     | `bigint`           |
# **`list_id`**            | `bigint`           |
# **`owner_id`**           | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_broadcasts_on_alliance_id`:
#     * **`alliance_id`**
# * `index_broadcasts_on_corporation_id`:
#     * **`corporation_id`**
# * `index_broadcasts_on_discarded_at`:
#     * **`discarded_at`**
# * `index_broadcasts_on_list_id`:
#     * **`list_id`**
# * `index_broadcasts_on_owner_id`:
#     * **`owner_id`**
# * `index_broadcasts_on_status`:
#     * **`status`**
# * `index_unique_broadcast_slugs` (_unique_):
#     * **`slug`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
# * `fk_rails_...`:
#     * **`list_id => lists.id`**
# * `fk_rails_...`:
#     * **`owner_id => users.id`**
#
require 'rails_helper'

RSpec.describe Broadcast, type: :model do
end
