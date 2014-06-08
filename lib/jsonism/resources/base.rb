module Jsonism
  module Resources
    class Base
      class << self
        attr_accessor :schema
      end

      # @param client [Jsonism::Client]
      # @param properties [Hash]
      def initialize(client: nil, properties: nil)
        @client = client
        @properties = properties
      end

      def to_hash
        @properties.clone
      end

      def changed?
        !changed_properties.empty?
      end

      def save
        @previously_changed_properties = changed_properties
        @changed_properties = {}
      end

      def change(name, value)
        changed_properties[name] = value
        @properties[name] = value
      end

      def changed_properties
        @changed_properties ||= {}
      end

      def previously_changed_properties
        @previously_changed_properties ||= {}
      end
    end
  end
end
