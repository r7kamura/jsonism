module Jsonism
  class Client
    # @param schema [Hash] JSON Schema
    # @raise [JsonSchema::SchemaError]
    def initialize(schema: nil)
      @schema = ::JsonSchema.parse!(schema).tap(&:expand_references!)
      define
    end

    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(url: base_url) do |connection|
        connection.request :json
        connection.response :json
        connection.adapter :net_http
      end
    end

    # @return [String] Base URL of API
    # @note Base URL is gained from the top-level link property whose `rel` is self
    # @raise [Jsonism::Client::BaseUrlNotFound]
    def base_url
      @base_url ||= root_link.try(:href) or raise BaseUrlNotFound
    end

    private

    # Defines some methods into itself from its JSON Schema
    def define
      Definer.call(client: self, schema: @schema)
    end

    # Finds link that has "self" rel to resolve API base URL
    # @return [JsonSchema::Schema::Link, nil]
    def root_link
      @schema.links.find do |link|
        link.rel == "self"
      end
    end

    class BaseUrlNotFound < Error
    end
  end
end
