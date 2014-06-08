module Jsonism
  module Resources
    class Base
      def initialize(properties)
        @properties = properties
      end

      def to_hash
        @properties
      end
    end
  end
end
