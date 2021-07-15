# frozen_string_literal: true

# ## Schema Information
#
# Table name: `list_conditions`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`ancestry`**        | `text`             |
# **`condition`**       | `text`             |
# **`discarded_at`**    | `datetime`         |
# **`kind`**            | `text`             | `not null`
# **`operator`**        | `text`             |
# **`position`**        | `integer`          | `not null`
# **`qualifier`**       | `text`             |
# **`subject`**         | `text`             |
# **`value`**           | `text`             |
# **`value_from`**      | `text`             |
# **`value_prefix`**    | `text`             |
# **`value_suffix`**    | `text`             |
# **`value_to`**        | `text`             |
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`alliance_id`**     | `bigint`           |
# **`corporation_id`**  | `bigint`           |
# **`list_id`**         | `bigint`           |
#
# ### Indexes
#
# * `index_list_conditions_on_alliance_id`:
#     * **`alliance_id`**
# * `index_list_conditions_on_ancestry`:
#     * **`ancestry`**
# * `index_list_conditions_on_corporation_id`:
#     * **`corporation_id`**
# * `index_list_conditions_on_discarded_at`:
#     * **`discarded_at`**
# * `index_list_conditions_on_list_id`:
#     * **`list_id`**
# * `index_unique_list_condition_positions` (_unique_):
#     * **`list_id`**
#     * **`ancestry`**
#     * **`position`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
# * `fk_rails_...`:
#     * **`list_id => lists.id`**
#
FactoryBot.define do
  factory :list_condition do
  end
end
