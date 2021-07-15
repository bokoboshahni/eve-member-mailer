# frozen_string_literal: true

module ESI
  class Client
    # ESI alliance client.
    module Alliances
      def alliance(alliance_id:)
        get("alliances/#{alliance_id}")
      end
    end
  end
end
