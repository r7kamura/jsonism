module Jsonism
  class Definer
    # Utility wrapper
    def self.call(*args)
      new(*args).call
    end

    # Recursively extracts all links from given JSON schema
    # @param schema [JsonSchema::Schema]
    # @return [Array<JsonSchema::Schema::Link>]
    def self.extract_links(schema)
      links = schema.links.select {|link| link.method && link.href }
      links + schema.properties.map {|key, schema| extract_links(schema) }.flatten
    end

    # @param client [Jsonism::Client]
    # @param schema [JsonSchema::Schema] JSON Schema
    def initialize(client: nil, schema: nil)
      @client = client
      @schema = schema
    end

    # Defines methods to call HTTP request from its JSON schema
    def call
      define_methods_into(@client)
      define_classes
    end

    private

    # @return [Array<JsonSchema::Schema::Link>] Links defined in its JSON schema
    def links
      @links ||= self.class.extract_links(@schema).map do |link|
        Link.new(link: link)
      end
    end

    def define_classes
      @schema.properties.each do |name, schema|
        unless Resources.const_defined?(name.camelize)
          Resources.const_set(name.camelize, Class.new(Resources::Base))
        end
      end
    end

    # Defines methods into client
    # @example
    #   client.list_app
    #   client.info_app(id: 1)
    def define_methods_into(client)
      links.each do |link|
        @client.define_singleton_method(link.method_signature) do |params = {}, headers = {}|
          Request.call(client: client, headers: headers, link: link, params: params)
        end
      end
    end
  end
end
