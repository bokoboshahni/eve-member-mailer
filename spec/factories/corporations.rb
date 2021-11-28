# frozen_string_literal: true

# ## Schema Information
#
# Table name: `corporations`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`description`**   | `text`             |
# **`discarded_at`**  | `datetime`         |
# **`icon_url_128`**  | `text`             |
# **`icon_url_256`**  | `text`             |
# **`icon_url_64`**   | `text`             |
# **`name`**          | `text`             | `not null`
# **`ticker`**        | `text`             | `not null`
# **`url`**           | `text`             |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`alliance_id`**   | `bigint`           |
# **`faction_id`**    | `integer`          |
#
# ### Indexes
#
# * `index_corporations_on_alliance_id`:
#     * **`alliance_id`**
# * `index_corporations_on_discarded_at`:
#     * **`discarded_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
#
FactoryBot.define do
  factory :corporation do
    name { Faker::Company.name }
    ticker { Faker::Finance.ticker[0..4] }
  end
end
