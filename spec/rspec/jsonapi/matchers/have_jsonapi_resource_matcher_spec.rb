require "spec_helper"

describe RSpec::JsonApi::Matchers::HaveJsonApiResourceMatcher do
  include RSpec::JsonApi::Matchers

  def fail_with(message)
    raise_error(RSpec::Expectations::ExpectationNotMetError, message)
  end

  let(:response) do
    json_body = body.is_a?(Hash) ? body.to_json : body
    double("Response", body: json_body)
  end

  context "when response is not JSON" do
    let(:body) { "none-json" }

    it "fails" do
      expect do
        expect(response).to have_jsonapi_resource(type: "customers", id: 13)
      end.to fail_with(/Response contains malformed JSON/)
    end
  end

  context "when there is not data property" do
    let(:body) { { "meta" => {} } }

    it "fails" do
      expect do
        expect(response).to have_jsonapi_resource(type: "customers", id: 13)
      end.to fail_with(/Response does not contain "data" property/)
    end
  end

  context "when type does not match" do
    let(:body) do
      { data: { type: "cats", id: "13" } }
    end

    it "fails" do
      expect do
        expect(response).to have_jsonapi_resource(type: "dogs", id: 13)
      end.to fail_with(/Expected resource type to be "dogs", but got "cats"/)
    end
  end

  context "when id does not match" do
    let(:body) do
      { data: { type: "dogs", id: "11" } }
    end

    it "fails" do
      expect do
        expect(response).to have_jsonapi_resource(type: "dogs", id: "13")
      end.to fail_with(/Expected resource id to be "13", but got "11"/)
    end
  end

  context "when id and type match" do
    let(:body) do
      { data: { type: "dogs", id: "13" } }
    end

    it "passes" do
      expect do
        expect(response).to have_jsonapi_resource(type: "dogs", id: 13)
      end.not_to raise_error
    end
  end

  context "when expectation with attributes" do
    let(:body) do
      {
        data: {
          type: "cats",
          id: "13",
          attributes: {
            name: "Tom",
            age: "3"
          }
        }
      }
    end

    context "one of attributes does not match" do
      it "fails" do
        expect do
          expect(response).to have_jsonapi_resource(type: "cats", id: 13, name: "Felix")
        end.to fail_with(/Expected attribute "name" to be "Felix", but got "Tom"/)
      end
    end

    context "all attributes match" do
      it "passes" do
        expect do
          expect(response).to have_jsonapi_resource(type: "cats", id: "13", name: "Tom")
          expect(response).to have_jsonapi_resource(type: "cats", id: "13", age: "3")
          expect(response).to have_jsonapi_resource(type: "cats", id: "13", name: "Tom", age: "3")
        end.not_to raise_error
      end
    end
  end
end
