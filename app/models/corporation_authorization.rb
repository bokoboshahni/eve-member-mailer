# frozen_string_literal: true

# ## Schema Information
#
# Table name: `corporation_authorizations`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`primary`**           | `boolean`          |
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`authorization_id`**  | `bigint`           | `not null`
# **`corporation_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_corporation_authorizations_on_authorization_id`:
#     * **`authorization_id`**
# * `index_corporation_authorizations_on_corporation_id`:
#     * **`corporation_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`authorization_id => authorizations.id`**
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
#
class CorporationAuthorization < ApplicationRecord
  audited

  belongs_to :corporation, inverse_of: :corporation_authorizations
  belongs_to :authorization, inverse_of: :corporation_authorization
end
