# frozen_string_literal: true

# ## Schema Information
#
# Table name: `user_characters`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`main`**          | `boolean`          | `default(FALSE), not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`character_id`**  | `bigint`           | `not null`
# **`user_id`**       | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_user_character_mains` (_unique_):
#     * **`character_id`**
#     * **`main`**
# * `index_unique_user_characters` (_unique_):
#     * **`character_id`**
# * `index_user_characters_on_character_id`:
#     * **`character_id`**
# * `index_user_characters_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#
class UserCharacter < ApplicationRecord
  belongs_to :character, inverse_of: :user_character
  belongs_to :user, inverse_of: :user_characters, touch: true

  has_one :corporation, through: :character

  delegate :authorized?, :name, to: :character, prefix: true
  delegate :name, to: :corporation, prefix: true
end
