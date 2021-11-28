# frozen_string_literal: true

# ## Schema Information
#
# Table name: `series_steps`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`body`**              | `text`             |
# **`delay`**             | `integer`          |
# **`deliver_at`**        | `time`             |
# **`discarded_at`**      | `datetime`         |
# **`kind`**              | `text`             | `not null`
# **`position`**          | `integer`          | `not null`
# **`status`**            | `text`             | `not null`
# **`subject`**           | `text`             |
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`authorization_id`**  | `bigint`           |
# **`series_id`**         | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_series_steps_on_authorization_id`:
#     * **`authorization_id`**
# * `index_series_steps_on_discarded_at`:
#     * **`discarded_at`**
# * `index_series_steps_on_series_id`:
#     * **`series_id`**
# * `index_unique_series_step_positions` (_unique_):
#     * **`series_id`**
#     * **`position`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`authorization_id => authorizations.id`**
# * `fk_rails_...`:
#     * **`series_id => series.id`**
#
FactoryBot.define do
  factory :series_step do
    series

    status { 'active' }

    trait :delay do
      delay { Faker::Number.within(range: 1..90) }
      kind { 'delay' }
    end

    trait :evemail do
      body { Faker::Lorem.paragraphs(number: 3) }
      kind { 'evemail' }
      subject { Faker::Lorem.sentence }
    end

    factory :evemail_series_step, traits: %i[evemail]
    factory :delay_series_step, traits: %i[delay]
  end
end
