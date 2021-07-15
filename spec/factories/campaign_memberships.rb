# frozen_string_literal: true

# ## Schema Information
#
# Table name: `campaign_memberships`
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
# **`campaign_id`**   | `bigint`           | `not null`
# **`character_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_campaign_memberships_on_campaign_id`:
#     * **`campaign_id`**
# * `index_campaign_memberships_on_campaign_id_and_entered_at`:
#     * **`campaign_id`**
#     * **`entered_at`**
# * `index_campaign_memberships_on_campaign_id_and_exited_at`:
#     * **`campaign_id`**
#     * **`exited_at`**
# * `index_campaign_memberships_on_campaign_id_and_status`:
#     * **`campaign_id`**
#     * **`status`**
# * `index_campaign_memberships_on_character_id`:
#     * **`character_id`**
# * `index_unique_campaign_characters` (_unique_):
#     * **`campaign_id`**
#     * **`character_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`campaign_id => campaigns.id`**
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
#
FactoryBot.define do
  factory :campaign_membership do
  end
end
