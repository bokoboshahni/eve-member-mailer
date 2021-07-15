# frozen_string_literal: true

# ## Schema Information
#
# Table name: `campaign_filters`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`ancestry`**      | `text`             |
# **`condition`**     | `text`             |
# **`discarded_at`**  | `datetime`         |
# **`kind`**          | `text`             | `not null`
# **`operator`**      | `text`             |
# **`position`**      | `integer`          | `not null`
# **`qualifier`**     | `text`             |
# **`subject`**       | `text`             |
# **`value`**         | `text`             |
# **`value_from`**    | `text`             |
# **`value_prefix`**  | `text`             |
# **`value_suffix`**  | `text`             |
# **`value_to`**      | `text`             |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`campaign_id`**   | `bigint`           |
#
# ### Indexes
#
# * `index_campaign_filters_on_ancestry`:
#     * **`ancestry`**
# * `index_campaign_filters_on_campaign_id`:
#     * **`campaign_id`**
# * `index_campaign_filters_on_discarded_at`:
#     * **`discarded_at`**
# * `index_unique_campaign_filter_positions` (_unique_):
#     * **`campaign_id`**
#     * **`ancestry`**
#     * **`position`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`campaign_id => campaigns.id`**
#
require 'rails_helper'

RSpec.describe CampaignFilter, type: :model do
end
