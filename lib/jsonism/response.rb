module Jsonism
  class Response
    # @param resource_class [Class]
    # @param response [Faraday::Response]
    def initialize(resource_class: nil, response: nil)
      @resource_class = resource_class
      @response = response
    end

    def body
      if has_list?
        @response.body.map do |element|
          @resource_class.new(element)
        end
      else
        @resource_class.new(@response.body)
      end
    end

    def headers
      @response.headers
    end

    def status
      @response.status
    end

    private

    def has_list?
      Array === @response.body
    end

    def raw_body
      @response.body
    end
  end
end
