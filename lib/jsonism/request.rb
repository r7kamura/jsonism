module Jsonism
  class Request
    # Utility wrapper
    def self.call(*args)
      new(*args).call
    end

    # @param client [Jsonism::Client]
    # @param headers [Hash]
    # @param link [Jsonism::Link]
    # @param params [Hash]
    def initialize(client: nil, headers: {}, link: nil, params: {})
      @client = client
      @headers = headers
      @link = link
      @params = params.with_indifferent_access
    end

    # Sends HTTP request
    def call
      @client.connection.send(method, path)
    end

    private

    def method
      @link.method.downcase
    end

    # @return [String] Path whose URI template is resolved
    # @example
    #   path #=> "/apps/1"
    def path
      path_with_template % path_params.symbolize_keys
    end

    # @return [String]
    # @example
    #   path_with_template #=> "/apps/%{id}"
    def path_with_template
      @link.href.gsub(/{(.+)}/) do |matched|
        key = CGI.unescape($1).gsub(/[()]/, "").split("/").last
        "%{#{key}}"
      end
    end

    # @return [Array<String>]
    # @exmaple
    #   path_keys #=> [:id]
    def path_keys
      @link.href.scan(/{(.+)}/).map do |str|
        CGI.unescape($1).gsub(/[()]/, "").split("/").last
      end
    end

    # @return [ActiveSupport::HashWithIndifferentAccess] Params to be embedded into path
    # @example
    #   path_params #=> { id: 1 }
    def path_params
      @params.slice(*path_keys)
    end

    # @return [ActiveSupport::HashWithIndifferentAccess] Params to be used for request body or query string
    # @example
    #   request_params #=> { name: "example" }
    def request_params
      @params.except(*path_keys)
    end
  end
end
