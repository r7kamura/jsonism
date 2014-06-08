module Jsonism
  class Link
    # @param schema [JsonSchema::Schema::Link]
    def initialize(link: nil)
      @link = link
    end

    def method_name
      link_title.underscore + "_" + schema_title.gsub(" ", "").underscore
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
