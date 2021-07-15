# frozen_string_literal: true

# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `bigint`           | `not null, primary key`
# **`admin`**               | `boolean`          |
# **`current_sign_in_at`**  | `datetime`         |
# **`current_sign_in_ip`**  | `inet`             |
# **`last_sign_in_at`**     | `datetime`         |
# **`last_sign_in_ip`**     | `inet`             |
# **`sign_in_count`**       | `integer`          | `default(0), not null`
# **`slug`**                | `text`             | `not null`
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_unique_user_slugs` (_unique_):
#     * **`slug`**
#
require 'rails_helper'

RSpec.describe User, type: :model do
end
