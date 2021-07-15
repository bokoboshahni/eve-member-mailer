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
# **`corporation_start_date`**  | `date`             |
# **`description`**             | `text`             |
# **`discarded_at`**            | `datetime`         |
# **`gender`**                  | `text`             | `not null`
# **`name`**                    | `text`             | `not null`
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
class Character < ApplicationRecord
  belongs_to :alliance, inverse_of: :characters, optional: true
  belongs_to :corporation, inverse_of: :characters

  has_many :authorizations, inverse_of: :character, dependent: :destroy
  has_many :campaign_memberships, inverse_of: :character, dependent: :restrict_with_exception
  has_many :deliveries, inverse_of: :character, dependent: :restrict_with_exception
  has_many :journeys, inverse_of: :character, dependent: :restrict_with_exception
  has_many :senders, inverse_of: :character, dependent: :restrict_with_exception

  has_one :user_character, inverse_of: :character, dependent: :restrict_with_exception
  has_one :user, through: :user_character

  def authorized?
    authorizations.any?
  end
end
