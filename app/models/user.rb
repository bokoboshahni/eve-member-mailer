# frozen_string_literal: true

# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`admin`**       | `boolean`          |
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
class User < ApplicationRecord
  devise :omniauthable

  has_many :audits, as: :user # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :login_activities, as: :user # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :series, foreign_key: :owner_id, inverse_of: :owner, dependent: :restrict_with_exception

  has_many :user_characters, inverse_of: :user, dependent: :delete_all
  has_many :characters, class_name: 'Character', through: :user_characters, inverse_of: :user
  has_many :accessible_corporations, class_name: 'Corporation', through: :characters, source: :corporation
  has_many :accessible_series, class_name: 'Series', through: :accessible_corporations, source: :series
  has_many :authorizations, through: :characters

  has_one :main_user_character, -> { where(main: true) }, class_name: 'UserCharacter', inverse_of: :user
  has_one :main_character, class_name: 'Character', through: :main_user_character, source: :character

  delegate :id, :name, to: :main_character, prefix: true
end
