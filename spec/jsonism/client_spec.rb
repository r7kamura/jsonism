require "spec_helper"

describe Jsonism::Client do
  describe ".new" do
    subject do
      described_class.new(schema: schema)
    end

    let(:schema) do
      JSON.parse(schema_body)
    end

    let(:schema_body) do
      File.read(schema_path)
    end

    let(:schema_path) do
      File.expand_path("../../fixtures/schema.json", __FILE__)
    end

    it "creates a new Jsonism::Client from given JSON Schema" do
      should be_a described_class
    end
  end
end
