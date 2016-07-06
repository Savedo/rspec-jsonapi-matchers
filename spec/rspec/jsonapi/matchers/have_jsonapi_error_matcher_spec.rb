require "spec_helper"

describe RSpec::JsonApi::Matchers::HaveJsonApiErrorMatcher do
  include RSpec::JsonApi::Matchers

  def fail_with(message)
    raise_error(RSpec::Expectations::ExpectationNotMetError, message)
  end

  let(:response) { double("Response", body: body) }

  context "when response is not JSON" do
    let(:body) { "none-json" }

    it "fails" do
      expect do
        expect(response).to have_jsonapi_error(code: "test", title: "Test")
      end.to fail_with(/Response contains malformed JSON/)
    end
  end

  context 'when response does not contain "errors" item' do
    let(:body) do
      {
        "data" => {
          "id" => "123",
          "type" => "foo",
          "attributes" => {
            "foo" => "bar"
          }
        }
      }.to_json
    end

    it "fails" do
      expect do
        expect(response).to have_jsonapi_error(code: "test", title: "Test")
      end.to fail_with(/Response does not contain "errors" item/)
    end
  end

  context "when response does not contain matching error" do
    let(:body) do
      { "errors" => [] }.to_json
    end

    it "fails" do
      expect do
        expect(response).to have_jsonapi_error(code: "test", title: "Test")
      end.to fail_with(/expected to have error/i)
    end
  end

  context "when response contain matching error" do
    let(:body) do
      {
        "errors" => [{ "code" => "test", "title" => "Test" }]
      }.to_json
    end

    it "passes" do
      expect(response).to have_jsonapi_error(code: "test", title: "Test")
    end
  end
end
