# frozen_string_literal: true

# ## Schema Information
#
# Table name: `progressions`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`paused_at`**     | `datetime`         |
# **`started_at`**    | `datetime`         |
# **`status`**        | `text`             | `not null`
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`character_id`**  | `bigint`           | `not null`
# **`series_id`**     | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_progressions_on_character_id`:
#     * **`character_id`**
# * `index_progressions_on_series_id`:
#     * **`series_id`**
# * `index_unique_progressions` (_unique_):
#     * **`series_id`**
#     * **`character_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`character_id => characters.id`**
# * `fk_rails_...`:
#     * **`series_id => series.id`**
#
class Progression < ApplicationRecord
  belongs_to :series, inverse_of: :progressions
  has_many :steps, through: :series

  belongs_to :character, inverse_of: :progressions

  has_many :events, class_name: 'ProgressionEvent', inverse_of: :progression, dependent: :destroy

  validates :status, presence: true
end
