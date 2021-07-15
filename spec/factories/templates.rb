# frozen_string_literal: true

# ## Schema Information
#
# Table name: `templates`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`body`**               | `text`             | `default(""), not null`
# **`description`**        | `text`             |
# **`discarded_at`**       | `datetime`         |
# **`name`**               | `text`             | `not null`
# **`slug`**               | `text`             | `not null`
# **`subject`**            | `text`             | `default(""), not null`
# **`uuid`**               | `uuid`             | `not null`
# **`validation_data`**    | `jsonb`            |
# **`validation_status`**  | `text`             |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`owner_id`**           | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_templates_on_discarded_at`:
#     * **`discarded_at`**
# * `index_templates_on_owner_id`:
#     * **`owner_id`**
# * `index_unique_template_slugs` (_unique_):
#     * **`slug`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`owner_id => users.id`**
#
FactoryBot.define do
  factory :template do
  end
end
