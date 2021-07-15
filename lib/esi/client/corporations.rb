# frozen_string_literal: true

module ESI
  class Client
    # ESI corporation client.
    module Corporations
      def corporation(corporation_id:)
        get("corporations/#{corporation_id}")
      end

      def corporation_alliance_history(corporation_id:)
        get("corporations/#{corporation_id}/alliancehistory")
      end

      def corporation_members(corporation_id:)
        get("corporations/#{corporation_id}/members")
      end
    end
  end
end
