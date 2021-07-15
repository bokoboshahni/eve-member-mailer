# frozen_string_literal: true

require 'esi/error'

module ESI
  # Client for the EVE Swagger Interface (ESI) API.
  class Client
    # ESI client error.
    class Error < ESI::Error
      attr_reader :response

      def initialize(msg, response:)
        super(msg)

        @response = response
      end
    end

    # ESI unauthorized error.
    class UnauthorizedError < Error; end

    # ESI bad request error.
    class BadRequestError < Error; end

    # ESI forbidden error.
    class ForbiddenError < Error; end

    # ESI not found error.
    class NotFoundError < Error; end

    # ESI unprocessable entity error.
    class UnprocessableEntityError < Error; end

    # ESI error limited error.
    class ErrorLimitedError < Error; end

    # ESI internal server error.
    class InternalServerError < Error; end

    # ESI service unavailable error.
    class ServiceUnavailableError < Error; end

    # ESI gateway timeout error.
    class GatewayTimeoutError < Error; end

    # ESI EVE server error.
    class EVEServerError < Error; end
  end
end
