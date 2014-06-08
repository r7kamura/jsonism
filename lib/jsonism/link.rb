module Jsonism
  class Link
    # @param schema [JsonSchema::Schema::Link]
    def initialize(link: nil)
      @link = link
    end

    # @return [String]
    # @example
    #   method_signature #=> "list_app"
    def method_signature
      link_title.underscore + "_" + schema_title.gsub(" ", "").underscore
    end

    # @return [String] Uppercase requet method
    # @example
    #   method #=> "GET"
    def method
      @link.method.to_s.upcase
    end

    # @return [Stirng]
    # @example
    #   href #=> "/apps"
    def href
      @link.href
    end

    private

    def schema_title
      schema.title
    end

    def link_title
      @link.title
    end

    def schema
      @link.target_schema || @link.parent
    end
  end
end
