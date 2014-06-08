require "spec_helper"

describe Jsonism::Client do
  let(:instance) do
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

  describe ".new" do
    subject do
      instance
    end

    it "creates a new Jsonism::Client from given JSON Schema" do
      should be_a described_class
    end

    it "defines some methods from links property" do
      should be_respond_to :create_app
      should be_respond_to :delete_app
      should be_respond_to :info_app
      should be_respond_to :list_app
      should be_respond_to :list_recipe
      should be_respond_to :update_app
    end
  end

  describe "#list_app" do
    subject do
      instance.list_app
    end

    it "sends HTTP request to GET /apps" do
      instance.connection.should_receive(:get).with("/apps")
      subject
    end
  end

  describe "#info_app" do
    subject do
      instance.info_app(id: 1)
    end

    it "sends HTTP request to GET /apps/:id" do
      instance.connection.should_receive(:get).with("/apps/1")
      subject
    end
  end
end
