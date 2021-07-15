# frozen_string_literal: true

# ## Schema Information
#
# Table name: `alliances`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`discarded_at`**  | `datetime`         |
# **`name`**          | `text`             | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`faction_id`**    | `integer`          |
#
# ### Indexes
#
# * `index_alliances_on_discarded_at`:
#     * **`discarded_at`**
#
require 'rails_helper'

RSpec.describe Alliance, type: :model do
end
