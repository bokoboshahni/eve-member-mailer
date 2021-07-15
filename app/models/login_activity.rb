# frozen_string_literal: true

# ## Schema Information
#
# Table name: `login_activities`
#
# ### Columns
#
# Name                       | Type               | Attributes
# -------------------------- | ------------------ | ---------------------------
# **`id`**                   | `bigint`           | `not null, primary key`
# **`city`**                 | `string`           |
# **`context`**              | `string`           |
# **`country`**              | `string`           |
# **`failure_reason`**       | `string`           |
# **`identity_bidx`**        | `string`           |
# **`identity_ciphertext`**  | `text`             |
# **`ip_bidx`**              | `string`           |
# **`ip_ciphertext`**        | `text`             |
# **`latitude`**             | `float`            |
# **`longitude`**            | `float`            |
# **`referrer`**             | `text`             |
# **`region`**               | `string`           |
# **`scope`**                | `string`           |
# **`strategy`**             | `string`           |
# **`success`**              | `boolean`          |
# **`user_agent`**           | `text`             |
# **`user_type`**            | `string`           |
# **`created_at`**           | `datetime`         |
# **`user_id`**              | `bigint`           |
#
# ### Indexes
#
# * `index_login_activities_on_identity_bidx`:
#     * **`identity_bidx`**
# * `index_login_activities_on_ip_bidx`:
#     * **`ip_bidx`**
# * `index_login_activities_on_user`:
#     * **`user_type`**
#     * **`user_id`**
#
class LoginActivity < ApplicationRecord
  belongs_to :user, polymorphic: true, optional: true

  encrypts :identity, :ip
  blind_index :identity, :ip

  before_save :reduce_precision

  # reduce precision to city level to protect IP
  def reduce_precision
    self.latitude = latitude&.round(1) if try(:latitude_changed?)
    self.longitude = longitude&.round(1) if try(:longitude_changed?)
  end
end
