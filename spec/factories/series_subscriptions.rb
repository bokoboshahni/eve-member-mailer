# frozen_string_literal: true

# ## Schema Information
#
# Table name: `series_subscriptions`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`entered_at`**    | `datetime`         |
# **`entry_reason`**  | `text`             |
# **`exit_reason`**   | `text`             |
# **`exited_at`**     | `datetime`         |
# **`status`**        | `text`             | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`character_id`**  | `bigint`           | `not null`
# **`series_id`**     | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_series_subscriptions_on_character_id`:
#     * **`character_id`**
# * `index_series_subscriptions_on_series_id`:
#     * **`series_id`**
# * `index_series_subscriptions_on_series_id_and_entered_at`:
#     * **`series_id`**
#     * **`entered_at`**
# * `index_series_subscriptions_on_series_id_and_exited_at`:
#     * **`series_id`**
#     * **`exited_at`**
# * `index_series_subscriptions_on_series_id_and_status`:
#     * **`series_id`**
#     * **`status`**
# * `index_unique_series_subscriptions` (_unique_):
#     * **`series_id`**
#     * **`character_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
# * `fk_rails_...`:
#     * **`series_id => series.id`**
#
FactoryBot.define do
  factory :series_subscription do
  end
end
