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
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
#
class Authorization < ApplicationRecord
  belongs_to :character, inverse_of: :authorization

  has_many :steps, class_name: 'SeriesStep', inverse_of: :authorization, dependent: :nullify

  has_one :corporation_authorization, inverse_of: :authorization, dependent: :destroy

  encrypts :access_token, :refresh_token

  validates :access_token, presence: true
  validates :expires_at, presence: true
  validates :refresh_token, presence: true

  def refresh_token!
    RefreshToken.call(self)
  end
end
