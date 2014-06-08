require "spec_helper"

describe Jsonism::Client do
  before do
    stub_request(:any, //).to_rack(mock_app)
  end

  let(:mock_app) do
    local_schema = schema
    Rack::Builder.new do
      use Rack::JsonSchema::Mock, schema: local_schema
      run ->(env) { [404, {}, ["Not Found"]] }
    end
  end

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

    context "with valid condition" do
      it "sends HTTP request to GET /apps" do
        instance.connection.should_receive(:get).with("/apps")
        subject
      end

      it "returns an Array of resources" do
        subject.body.should be_a Array
        subject.body[0].should be_a Jsonism::Resources::App
      end
    end
  end

  describe "#info_app" do
    subject do
      instance.info_app(params)
    end

    let(:params) do
      { id: 1 }
    end

    context "with valid condition" do
      it "sends HTTP request to GET /apps/:id" do
        instance.connection.should_receive(:get).with("/apps/1")
        subject
      end

      it "returns a Jsonism::Response" do
        should be_a Jsonism::Response
      end

      it "returns status, headers, and body data" do
        subject.status.should == 200
        subject.headers.should be_a Hash
        subject.body.should be_a Jsonism::Resources::App
      end
    end

    context "with missing params" do
      before do
        params.delete(:id)
      end

      it "raises Jsonism::Request::MissingParams" do
        expect { subject }.to raise_error(Jsonism::Request::MissingParams, "id params are missing")
      end
    end
  end
end
