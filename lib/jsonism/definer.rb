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

    # Defines methods to call HTTP request from its JSON schema
    def call
      client = @client
      links.each do |link|
        @client.define_singleton_method(link.method_signature) do |params = {}, headers = {}|
          Request.call(client: client, headers: headers, link: link, params: params)
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
