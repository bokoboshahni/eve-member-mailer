# frozen_string_literal: true

# ## Schema Information
#
# Table name: `journeys`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`paused_at`**     | `datetime`         |
# **`started_at`**    | `datetime`         |
# **`status`**        | `text`             | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`campaign_id`**   | `bigint`           | `not null`
# **`character_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_journeys_on_campaign_id`:
#     * **`campaign_id`**
# * `index_journeys_on_campaign_id_and_character_id`:
#     * **`campaign_id`**
#     * **`character_id`**
# * `index_journeys_on_character_id`:
#     * **`character_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`campaign_id => campaigns.id`**
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
#
class Journey < ApplicationRecord
  belongs_to :campaign, inverse_of: :journeys
  belongs_to :character, inverse_of: :journeys

  has_many :journey_steps, inverse_of: :journey, dependent: :restrict_with_exception
end
