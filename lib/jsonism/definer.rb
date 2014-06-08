module Jsonism
  class Definer
    # Utility wrapper
    def self.call(*args)
      new(*args).call
    end

    # Recursively extracts all links from given JSON schema
    # @param schema [JsonSchema::Schema]
    # @raise [JsonSchema::SchemaError]
    # @return [Array<JsonSchema::Schema::Link>]
    def self.extract_links(schema)
      links = schema.links.select {|link| link.method && link.href }
      links + schema.properties.map {|key, schema| extract_links(schema) }.flatten
    end

    # @param client [Jsonism::Client]
    # @param schema [Hash] JSON Schema
    def initialize(client: nil, schema: nil)
      @client = client
      @schema = ::JsonSchema.parse!(schema).tap(&:expand_references!)
    end

    # Defines some methods into its client from its JSON schema
    def call
      links.each do |link|
        @client.define_singleton_method(link.method_name) do |params = {}, headers = {}|
          p [link.method_name, params, headers]
        end
      end
    end

    private

    # @return [Array<JsonSchema::Schema::Link>] Links defined in its JSON schema
    def links
      @links ||= self.class.extract_links(@schema).map do |link|
        Link.new(link: link)
      end
    end
  end
end
