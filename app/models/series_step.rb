# frozen_string_literal: true

# ## Schema Information
#
# Table name: `series_steps`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`body`**              | `text`             |
# **`delay`**             | `integer`          |
# **`deliver_at`**        | `time`             |
# **`discarded_at`**      | `datetime`         |
# **`kind`**              | `text`             | `not null`
# **`position`**          | `integer`          | `not null`
# **`status`**            | `text`             | `not null`
# **`subject`**           | `text`             |
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`authorization_id`**  | `bigint`           |
# **`series_id`**         | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_series_steps_on_authorization_id`:
#     * **`authorization_id`**
# * `index_series_steps_on_discarded_at`:
#     * **`discarded_at`**
# * `index_series_steps_on_series_id`:
#     * **`series_id`**
# * `index_unique_series_step_positions` (_unique_):
#     * **`series_id`**
#     * **`position`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`authorization_id => authorizations.id`**
# * `fk_rails_...`:
#     * **`series_id => series.id`**
#
class SeriesStep < ApplicationRecord
  belongs_to :series, inverse_of: :steps
  belongs_to :authorization, inverse_of: :series_steps, optional: true

  has_many :events, class_name: 'ProgressionEvent', inverse_of: :step, dependent: :restrict_with_exception

  acts_as_list scope: :series
end