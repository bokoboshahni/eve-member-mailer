# frozen_string_literal: true

# ## Schema Information
#
# Table name: `alliances`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`discarded_at`**  | `datetime`         |
# **`icon_url_128`**  | `text`             |
# **`icon_url_64`**   | `text`             |
# **`name`**          | `text`             | `not null`
# **`ticker`**        | `text`             | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`faction_id`**    | `integer`          |
#
# ### Indexes
#
# * `index_alliances_on_discarded_at`:
#     * **`discarded_at`**
#
class Alliance < ApplicationRecord
  has_many :corporations, inverse_of: :alliance, dependent: :restrict_with_exception

  def sync_from_esi!
    Alliance::SyncFromESI.call(id)
  end
end
