# frozen_string_literal: true

# ## Schema Information
#
# Table name: `authorizations`
#
# ### Columns
#
# Name                            | Type               | Attributes
# ------------------------------- | ------------------ | ---------------------------
# **`id`**                        | `bigint`           | `not null, primary key`
# **`access_token_ciphertext`**   | `text`             | `not null`
# **`expires_at`**                | `datetime`         | `not null`
# **`kind`**                      | `text`             | `not null`
# **`refresh_token_ciphertext`**  | `text`             | `not null`
# **`scopes`**                    | `text`             | `default([]), not null, is an Array`
# **`created_at`**                | `datetime`         | `not null`
# **`updated_at`**                | `datetime`         | `not null`
# **`character_id`**              | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_authorizations_on_character_id`:
#     * **`character_id`**
# * `index_authorizations_on_kind`:
#     * **`kind`**
# * `index_unique_authorizations` (_unique_):
#     * **`character_id`**
#     * **`kind`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
#
class Authorization < ApplicationRecord
  KINDS = %w[esi].freeze

  belongs_to :character, inverse_of: :authorizations

  encrypts :access_token, :refresh_token

  validates :access_token, presence: true
  validates :expires_at, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :refresh_token, presence: true
end
