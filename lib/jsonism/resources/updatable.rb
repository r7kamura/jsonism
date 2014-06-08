module Jsonism
  module Resources
    module Updatable
      extend ActiveSupport::Concern

      def update(params = {}, headers = {})
        Request.call(
          client: @client,
          headers: headers,
          link: self.class.link_for_update,
          params: read_only_properties.merge(changed_properties.merge(params)),
        )
      end

      module ClassMethods
        attr_accessor :link_for_update
      end
    end
  end
end
