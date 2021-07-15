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
class Alliance < ApplicationRecord
  has_many :broadcasts, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :campaign_triggers, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :characters, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :corporation_memberships, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :corporations, inverse_of: :alliance, dependent: :restrict_with_exception
  has_many :deliveries, inverse_of: :alliance_id, dependent: :restrict_with_exception
  has_many :list_conditions, inverse_of: :alliance, dependent: :restrict_with_exception
end
