# frozen_string_literal: true

# ## Schema Information
#
# Table name: `senders`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`broadcast_id`**  | `bigint`           |
# **`campaign_id`**   | `bigint`           |
# **`character_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_senders_on_broadcast_id`:
#     * **`broadcast_id`**
# * `index_senders_on_campaign_id`:
#     * **`campaign_id`**
# * `index_senders_on_character_id`:
#     * **`character_id`**
# * `index_unique_sender_broadcast_characters` (_unique_):
#     * **`character_id`**
#     * **`broadcast_id`**
# * `index_unique_sender_campaign_characters` (_unique_):
#     * **`character_id`**
#     * **`campaign_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`broadcast_id => broadcasts.id`**
# * `fk_rails_...`:
#     * **`campaign_id => campaigns.id`**
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
#
FactoryBot.define do
  factory :sender do
  end
end
