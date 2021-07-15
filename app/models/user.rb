# frozen_string_literal: true

# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `bigint`           | `not null, primary key`
# **`admin`**               | `boolean`          |
# **`current_sign_in_at`**  | `datetime`         |
# **`current_sign_in_ip`**  | `inet`             |
# **`last_sign_in_at`**     | `datetime`         |
# **`last_sign_in_ip`**     | `inet`             |
# **`sign_in_count`**       | `integer`          | `default(0), not null`
# **`slug`**                | `text`             | `not null`
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_unique_user_slugs` (_unique_):
#     * **`slug`**
#
class User < ApplicationRecord
  include SlugConcern

  devise :omniauthable

  has_many :broadcasts, foreign_key: :owner_id, inverse_of: :owner, dependent: :restrict_with_exception
  has_many :campaigns, foreign_key: :owner_id, inverse_of: :owner, dependent: :restrict_with_exception
  has_many :lists, foreign_key: :owner_id, inverse_of: :owner, dependent: :restrict_with_exception
  has_many :team_invitations_received, class_name: 'TeamInvitation', foreign_key: 'invitee_id', inverse_of: :invitee,
                                       dependent: :restrict_with_exception
  has_many :team_invitations_sent, class_name: 'TeamInvitation', foreign_key: 'inviter_id', inverse_of: :inviter,
                                   dependent: :restrict_with_exception
  has_many :templates, foreign_key: :owner_id, inverse_of: :owner, dependent: :restrict_with_exception

  has_many :team_memberships, inverse_of: :user, dependent: :restrict_with_exception
  has_many :teams, through: :team_memberships

  has_many :user_characters, inverse_of: :user, dependent: :delete_all
  has_many :characters, class_name: 'Character', through: :user_characters, inverse_of: :user

  has_one :main_user_character, -> { where(main: true) }, class_name: 'UserCharacter', inverse_of: :user
  has_one :main_character, class_name: 'Character', through: :main_user_character, source: :character

  delegate :id, :name, to: :main_character, prefix: true
end
