module Jsonism
  class Response
    # @param client [Jsonism::Client]
    # @param resource_class [Class]
    # @param response [Faraday::Response]
    def initialize(client: nil, resource_class: nil, response: nil)
      @client = client
      @resource_class = resource_class
      @response = response
    end

    def body
      if has_list?
        @response.body.map do |properties|
          @resource_class.new(client: @client, properties: properties)
        end
      else
        @resource_class.new(client: @client, properties: @response.body)
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
