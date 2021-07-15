# frozen_string_literal: true

# ## Schema Information
#
# Table name: `campaign_triggers`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`date_attribute`**  | `integer`          |
# **`date_day`**        | `integer`          |
# **`date_month`**      | `integer`          |
# **`date_window`**     | `integer`          |
# **`date_year`**       | `integer`          |
# **`kind`**            | `text`             | `not null`
# **`qualifier`**       | `text`             |
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`campaign_id`**     | `bigint`           | `not null`
# **`list_id`**         | `bigint`           |
#
# ### Indexes
#
# * `index_campaign_triggers_on_campaign_id`:
#     * **`campaign_id`**
# * `index_campaign_triggers_on_list_id`:
#     * **`list_id`**
# * `index_unique_campaign_trigger_lists` (_unique_):
#     * **`campaign_id`**
#     * **`list_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`campaign_id => campaigns.id`**
# * `fk_rails_...`:
#     * **`list_id => lists.id`**
#
class CampaignTrigger < ApplicationRecord
  KINDS = {
    list: 'List'
    # date: 'Date'
  }.freeze

  audited meta: { campaign_id: :campaign_id }

  belongs_to :campaign, inverse_of: :triggers, touch: true

  belongs_to :alliance, inverse_of: :campaign_triggers, optional: true
  belongs_to :corporation, inverse_of: :campaign_triggers, optional: true
  belongs_to :list, inverse_of: :campaign_triggers, optional: true

  validates :alliance_id, uniqueness: { scope: :campaign_id, message: 'is already being used in a trigger' },
                          allow_blank: true
  validates :corporation_id, uniqueness: { scope: :campaign_id, message: 'is already being used in a trigger' },
                             allow_blank: true
  validates :kind, presence: true, inclusion: { in: KINDS.keys.map(&:to_s) }
  validates :list_id, uniqueness: { scope: :campaign_id, message: 'is already being used in a trigger' },
                      allow_blank: true
end
