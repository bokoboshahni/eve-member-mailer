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
# **`icon_url_128`**  | `text`             |
# **`icon_url_256`**  | `text`             |
# **`icon_url_64`**   | `text`             |
# **`name`**          | `text`             | `not null`
# **`ticker`**        | `text`             | `not null`
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

  has_many :characters, inverse_of: :corporation, dependent: :destroy
  has_many :series, inverse_of: :corporation, dependent: :destroy

  has_many :sync_corporation_membership_statuses, -> { where(kind: 'sync_corporation_memberships') },
           class_name: 'BatchStatus',
           as: :subject,
           inverse_of: :subject

  has_many :corporation_authorizations, inverse_of: :corporation, dependent: :destroy
  has_many :authorizations, through: :corporation_authorizations

  has_one :primary_corporation_authorization, lambda {
                                                where(primary: true)
                                              }, class_name: 'CorporationAuthorization', inverse_of: :corporation
  has_one :primary_authorization, class_name: 'Authorization', through: :primary_corporation_authorization,
                                  source: :authorization

  def sync_from_esi!
    Corporation::SyncFromESI.call(id)
  end
end
