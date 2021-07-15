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
require 'rails_helper'

RSpec.describe Authorization, type: :model, vcr: true do
  let(:character) { SyncESICharacter.new('96224792').call }

  it 'is valid with valid attributes' do
    expect(FactoryBot.build(:authorization, character: character)).to be_valid
  end

  it 'is invalid without an associated character' do
    expect(FactoryBot.build(:authorization, character: nil)).not_to be_valid
  end

  it 'is invalid without an access token' do
    expect(FactoryBot.build(:authorization, character: character, access_token: nil)).not_to be_valid
  end

  it 'is invalid without an expiration timestamp' do
    expect(FactoryBot.build(:authorization, character: character, expires_at: nil)).not_to be_valid
  end

  it 'is invalid without a kind' do
    expect(FactoryBot.build(:authorization, character: character, kind: nil)).not_to be_valid
  end

  it 'is invalid with an unacceptable kind' do
    expect(FactoryBot.build(:authorization, character: character, kind: 'asdf')).not_to be_valid
  end

  it 'is invalid without a refresh token' do
    expect(FactoryBot.build(:authorization, character: character, refresh_token: nil)).not_to be_valid
  end
end
