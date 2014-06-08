module Jsonism
  module Resources
    module Deletable
      extend ActiveSupport::Concern

      def delete(params = {}, headers = {})
        Request.call(
          client: @client,
          headers: headers,
          link: self.class.link_for_deletion,
          params: to_hash,
          ignore_request_params: true,
        )
      end

      module ClassMethods
        attr_accessor :link_for_deletion
      end
    end
  end
end
