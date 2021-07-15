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
# **`name`**          | `text`             | `not null`
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
class Corporation < ApplicationRecord
  belongs_to :alliance, inverse_of: :corporations, optional: true

  has_many :broadcasts, inverse_of: :corporation, dependent: :restrict_with_exception
  has_many :campaign_triggers, inverse_of: :corporation, dependent: :restrict_with_exception
  has_many :characters, inverse_of: :corporation, dependent: :restrict_with_exception
  has_many :deliveries, inverse_of: :corporation, dependent: :restrict_with_exception
end
