# frozen_string_literal: true

# ## Schema Information
#
# Table name: `lists`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`description`**     | `text`             |
# **`discarded_at`**    | `datetime`         |
# **`kind`**            | `text`             | `not null`
# **`name`**            | `text`             | `not null`
# **`qualifier`**       | `text`             | `not null`
# **`slug`**            | `text`             | `not null`
# **`status`**          | `text`             | `not null`
# **`status_data`**     | `jsonb`            |
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`corporation_id`**  | `bigint`           | `not null`
# **`owner_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_lists_on_corporation_id`:
#     * **`corporation_id`**
# * `index_lists_on_discarded_at`:
#     * **`discarded_at`**
# * `index_lists_on_owner_id`:
#     * **`owner_id`**
# * `index_lists_on_status`:
#     * **`status`**
# * `index_unique_list_slug` (_unique_):
#     * **`slug`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
# * `fk_rails_...`:
#     * **`owner_id => users.id`**
#
class List < ApplicationRecord
  include Discard::Model
  include SlugConcern

  KINDS = {
    auto: 'Automated',
    manual: 'Manual'
  }.freeze

  CONDITION_QUANTIFIERS = {
    all: 'All',
    any: 'Any'
  }.freeze

  has_paper_trail

  belongs_to :corporation, inverse_of: :lists

  has_many :broadcasts, inverse_of: :list, dependent: :restrict_with_exception
  has_many :conditions, inverse_of: :list, class_name: 'ListCondition', dependent: :destroy

  has_many :character_memberships, class_name: 'ListMembership', inverse_of: :list,
                                   dependent: :destroy
  has_many :member_characters, class_name: 'EVECharacter', through: :character_memberships, source: :character

  has_many :campaign_triggers, inverse_of: :list, dependent: :restrict_with_exception
  has_many :triggered_campaigns, through: :triggers, source: :campaign

  validates :condition_quantifier, inclusion: { in: CONDITION_QUANTIFIERS.keys.map(&:to_s) }
  validates :kind, presence: true, inclusion: { in: KINDS.keys.map(&:to_s) }
  validates :name, presence: true
end
