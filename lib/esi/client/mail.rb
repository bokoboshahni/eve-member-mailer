# frozen_string_literal: true

module ESI
  class Client
    # ESI mail client.
    module Mail
      def send(character_id:, body:, subject:, recipients:)
        post("characters/#{character_id}", body: { body: body, subject: subject, recipients: recipients })
      end
    end
  end
end
