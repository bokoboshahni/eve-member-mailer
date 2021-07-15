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
require 'rails_helper'

RSpec.describe CampaignTrigger, type: :model do
end
