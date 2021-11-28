# frozen_string_literal: true

# ## Schema Information
#
# Table name: `characters`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `bigint`           | `not null, primary key`
# **`birthday`**                | `date`             | `not null`
# **`corporation_roles`**       | `text`             | `default([]), not null, is an Array`
# **`corporation_start_date`**  | `date`             |
# **`description`**             | `text`             |
# **`discarded_at`**            | `datetime`         |
# **`gender`**                  | `text`             | `not null`
# **`name`**                    | `text`             | `not null`
# **`portrait_url_128`**        | `text`             |
# **`portrait_url_256`**        | `text`             |
# **`portrait_url_512`**        | `text`             |
# **`portrait_url_64`**         | `text`             |
# **`security_status`**         | `decimal(, )`      |
# **`title`**                   | `text`             |
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
# **`alliance_id`**             | `bigint`           |
# **`ancestry_id`**             | `integer`          |
# **`bloodline_id`**            | `integer`          | `not null`
# **`corporation_id`**          | `bigint`           | `not null`
# **`faction_id`**              | `integer`          |
# **`race_id`**                 | `integer`          | `not null`
#
# ### Indexes
#
# * `index_characters_on_alliance_id`:
#     * **`alliance_id`**
# * `index_characters_on_corporation_id`:
#     * **`corporation_id`**
# * `index_characters_on_discarded_at`:
#     * **`discarded_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
#
FactoryBot.define do
  factory :character do
    corporation

    birthday { Faker::Date.birthday(min_age: 18, max_age: 65) }
    bloodline_id { 1 }
    corporation_start_date { Faker::Date.between(from: 10.years.ago, to: Date.today) }
    race_id { 1 }
    gender { Faker::Gender.binary_type.downcase }
    name { Faker::Name.name }
  end
end
