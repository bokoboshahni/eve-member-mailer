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
require 'rails_helper'

RSpec.describe UserCharacter, type: :model, vcr: true do
  let(:character) { SyncESICharacter.new('96224792').call }
  let(:user) { FactoryBot.create(:user) }

  it 'is valid with valid attributes' do
    expect(described_class.new(character: character, user: user)).to be_valid
  end

  it 'is invalid without an associated character' do
    expect(described_class.new(user: user)).not_to be_valid
  end

  it 'is invalid without an associated user' do
    expect(described_class.new(character: character)).not_to be_valid
  end
end
