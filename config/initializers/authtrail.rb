# frozen_string_literal: true

# set to true for geocoding
# we recommend configuring local geocoding first
# see https://github.com/ankane/authtrail#geocoding
AuthTrail.geocode = false

# add or modify data
# AuthTrail.transform_method = lambda do |data, request|
#   data[:request_id] = request.request_id
# end

# exclude certain attempts from tracking
# AuthTrail.exclude_method = lambda do |data|
#   data[:identity] == "capybara@example.org"
# end

# AuthTrail.identity_method = lambda do |_request, _opts, user|
#   user.main_character_id if user
# end
