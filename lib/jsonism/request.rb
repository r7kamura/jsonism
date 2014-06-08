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
      if has_valid_params?
        Response.new(
          resource_class: resource_class,
          response: @client.connection.send(method, path),
        )
      else
        raise MissingParams, missing_params
      end
    end

    private

    # @return [Class] Auto-defined resource class
    def resource_class
      Resources.const_get(resource_class_name)
    end

    def resource_class_name
      @link.schema_title.camelize
    end

    # @return [true, false] False if any keys in path template are missing
    def has_valid_params?
      missing_params.empty?
    end

    # @return [Array<Stirng>] Missing parameter names
    def missing_params
      @missing_params ||= path_keys - @params.keys
    end

    # @return [Array<String>] Parameter names marked as readonly
    def read_only_params
      @read_only_params ||= @link.schema.properties.map do |name, property|
        name if property.read_only
      end.compact
    end

    # @return [String] Method name to call connection's methods
    # @example
    #   method #=> "get"
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

    # @return [Array<String>] Parameter names required for path
    # @exmaple
    #   path_keys #=> ["id"]
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
      @params.except(*path_keys, *read_only_params)
    end

    class MissingParams < Error
      def initialize(missing_params)
        @missing_params = missing_params
      end

      def to_s
        @missing_params.join(", ") + " params are missing"
      end
    end
  end
end
