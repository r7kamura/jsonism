module Jsonism
  class Client
    # @param schema [Hash] JSON Schema
    def initialize(schema: nil)
      @schema = schema
    end
  end
end
