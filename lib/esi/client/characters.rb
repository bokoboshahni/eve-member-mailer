# frozen_string_literal: true

module ESI
  class Client
    # ESI character client.
    module Characters
      def character(character_id:)
        get("characters/#{character_id}")
      end

      def character_corporation_history(character_id:)
        get("characters/#{character_id}/corporationhistory")
      end

      def character_roles(character_id:)
        get("characters/#{character_id}/roles", auth: { character_id: character_id })
      end
    end
  end
end
