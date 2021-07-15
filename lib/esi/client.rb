# frozen_string_literal: true

require_relative './client/error'
require_relative './client/alliances'
require_relative './client/characters'
require_relative './client/corporations'
require_relative './client/mail'

module ESI
  # Client for the EVE Swagger Interface (ESI) API.
  class Client
    include ESI::Client::Alliances
    include ESI::Client::Characters
    include ESI::Client::Corporations
    include ESI::Client::Mail

    DEFAULT_BASE_URL = 'https://esi.evetech.net'
    DEFAULT_VERSION = 'latest'

    ERROR_MAPPING = {
      400 => ESI::Client::BadRequestError,
      401 => ESI::Client::UnauthorizedError,
      403 => ESI::Client::ForbiddenError,
      404 => ESI::Client::NotFoundError,
      420 => ESI::Client::ErrorLimitedError,
      422 => ESI::Client::UnprocessableEntityError,
      500 => ESI::Client::InternalServerError,
      503 => ESI::Client::ServiceUnavailableError,
      504 => ESI::Client::GatewayTimeoutError,
      520 => ESI::Client::EVEServerError
    }.freeze

    attr_reader :base_url, :user_agent, :version

    def initialize(user_agent:, base_url: DEFAULT_BASE_URL, version: DEFAULT_VERSION)
      @base_url = base_url
      @user_agent = user_agent
      @version = version
    end

    def get(path, params: {}, headers: {})
      response = make_get_request(path, params: params, headers: headers)

      return paginate(response, params, headers) if paginated?(response)

      response.body
    end

    def post(path, body: {}, params: {}, headers: {})
      response = make_post_request(path, body: body, params: params, headers: headers)
      response.body
    end

    def authorize(_token)
      connection.authorization :Bearer, uc.esi_access_token
    end

    private

    ESI_RETRY_EXCEPTIONS = [Errno::ETIMEDOUT, Timeout::Error, Faraday::TimeoutError, Faraday::ConnectionFailed,
                            Faraday::ParsingError, SocketError].freeze

    def paginate(response, params, headers)
      all_items = response.body
      page_count = response.headers['X-Pages'].to_i - 1
      page_count.times do |n|
        page_number = n + 1
        params = params.merge(page: page_number)
        page = make_get_request(path, params: params, headers: headers)
        all_items += page.body
      end

      all_items
    end

    def make_get_request(path, params: {}, headers: {})
      res = get_connection.get("/#{version}/#{path}", params, headers)

      raise_error(res) unless res.success?

      res
    end

    def make_post_request(path, body: {}, headers: {})
      post_connection.post("/#{version}/#{path}", body, headers)

      raise_error(res) unless res.success?

      res
    end

    def paginated?(response)
      response.headers['X-Pages'] && response.headers['X-Pages'].to_i <= 1
    end

    def raise_error(res)
      raise (ERROR_MAPPING[res.status] || Error).new("(#{res.status}) #{res['error']}", response: res)
    end

    def get_connection # rubocop:disable Naming/AccessorMethodName
      @get_connection ||= Faraday.new(base_url, headers: default_headers) do |f|
        f.use :http_cache, store: Rails.cache, logger: Rails.logger, instrumenter: ActiveSupport::Notifications
        f.request :url_encoded
        f.request :retry, { exceptions: ESI_RETRY_EXCEPTIONS }
        f.response :follow_redirects
        f.response :json
      end
    end

    def post_connection
      @post_connection ||= Faraday.new(base_url, headers: default_headers) do |f|
        f.use :http_cache, store: Rails.cache, logger: Rails.logger, instrumenter: ActiveSupport::Notifications
        f.request :json
        f.request :retry, { exceptions: ESI_RETRY_EXCEPTIONS }
        f.response :follow_redirects
        f.response :json
      end
    end

    def default_headers
      { 'User-Agent': user_agent }
    end
  end
end
