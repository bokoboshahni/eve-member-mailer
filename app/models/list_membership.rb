# frozen_string_literal: true

# ## Schema Information
#
# Table name: `list_memberships`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`discarded_at`**  | `datetime`         |
# **`entered_at`**    | `datetime`         |
# **`entry_reason`**  | `text`             |
# **`exit_reason`**   | `text`             |
# **`exited_at`**     | `datetime`         |
# **`status`**        | `text`             | `not null`
# **`status_data`**   | `jsonb`            |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`character_id`**  | `bigint`           | `not null`
# **`list_id`**       | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_list_character_statuses`:
#     * **`list_id`**
#     * **`character_id`**
#     * **`status`**
# * `index_list_memberships_on_character_id`:
#     * **`character_id`**
# * `index_list_memberships_on_discarded_at`:
#     * **`discarded_at`**
# * `index_list_memberships_on_list_id`:
#     * **`list_id`**
# * `index_list_memberships_on_list_id_and_entered_at`:
#     * **`list_id`**
#     * **`entered_at`**
# * `index_list_memberships_on_list_id_and_exited_at`:
#     * **`list_id`**
#     * **`exited_at`**
# * `index_unique_list_characters` (_unique_):
#     * **`list_id`**
#     * **`character_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
# * `fk_rails_...`:
#     * **`list_id => lists.id`**
#
class ListMembership < ApplicationRecord
  belongs_to :list, inverse_of: :character_memberships
  belongs_to :character, class_name: 'EVECharacter', inverse_of: :list_memberships
end
