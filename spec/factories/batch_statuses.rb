# frozen_string_literal: true

# ## Schema Information
#
# Table name: `batch_statuses`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`completed_at`**  | `datetime`         |
# **`failure_info`**  | `jsonb`            |
# **`failures`**      | `integer`          |
# **`jobs`**          | `integer`          |
# **`kind`**          | `text`             | `not null`
# **`status`**        | `text`             | `not null`
# **`subject_type`**  | `string`           |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`subject_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_batch_statuses_on_subject`:
#     * **`subject_type`**
#     * **`subject_id`**
#
FactoryBot.define do
  factory :batch_status do
  end
end
