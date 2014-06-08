module Jsonism
  class Client
    # @param schema [Hash] JSON Schema
    def initialize(schema: nil)
      @schema = schema
      define
    end

    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new
    end

    private

    # Defines some methods into itself from its JSON Schema
    def define
      Definer.call(client: self, schema: @schema)
    end
  end
end
