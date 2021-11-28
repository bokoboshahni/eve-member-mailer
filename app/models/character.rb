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
class Character < ApplicationRecord
  belongs_to :alliance, inverse_of: :characters, optional: true
  belongs_to :corporation, inverse_of: :characters

  has_many :deliveries_received, class_name: 'Delivery', foreign_key: :receiver_id, inverse_of: :receiver,
                                 dependent: :destroy
  has_many :deliveries_sent, class_name: 'Delivery', foreign_key: :sender_id, inverse_of: :sender, dependent: :destroy

  has_many :series_subscriptions, inverse_of: :character, dependent: :destroy
  has_many :progressions, inverse_of: :character, dependent: :destroy

  has_one :authorization, inverse_of: :character, dependent: :destroy
  has_one :user_character, inverse_of: :character, dependent: :destroy
  has_one :user, through: :user_character

  def authorized?
    authorization.present?
  end

  def sync_from_esi!
    Character::SyncFromESI.call(id)
  end
end
