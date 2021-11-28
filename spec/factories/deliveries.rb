# frozen_string_literal: true

# ## Schema Information
#
# Table name: `deliveries`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`id`**             | `bigint`           | `not null, primary key`
# **`body`**           | `text`             |
# **`delivered_at`**   | `datetime`         |
# **`failed_at`**      | `datetime`         |
# **`kind`**           | `text`             | `not null`
# **`scheduled_for`**  | `datetime`         |
# **`status`**         | `text`             | `not null`
# **`subject`**        | `text`             |
# **`uuid`**           | `uuid`             | `not null`
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`evemail_id`**     | `integer`          |
# **`recipient_id`**   | `bigint`           |
# **`sender_id`**      | `bigint`           |
#
# ### Indexes
#
# * `index_deliveries_on_kind`:
#     * **`kind`**
# * `index_deliveries_on_recipient_id`:
#     * **`recipient_id`**
# * `index_deliveries_on_sender_id`:
#     * **`sender_id`**
# * `index_deliveries_on_status`:
#     * **`status`**
# * `index_unique_delivery_uuid` (_unique_):
#     * **`uuid`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`recipient_id => characters.id`**
# * `fk_rails_...`:
#     * **`sender_id => characters.id`**
#
FactoryBot.define do
  factory :delivery do
  end
end
