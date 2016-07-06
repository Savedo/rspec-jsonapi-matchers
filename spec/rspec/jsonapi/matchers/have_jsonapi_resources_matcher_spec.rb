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

  let(:body) do
    {
      data: [
        {
          type: "cats",
          id: "13",
          attributes: {
            name: "Felix"
          }
        },
        {
          type: "dogs",
          id: "2",
          attributes: {
            name: "Snoopy",
            owner: "Charlie"
          }
        }
      ]
    }
  end

  context "when hash is passed instead of array" do
    it "raises exception" do
      expect do
        expect(response).to have_jsonapi_resources(a: 10)
      end.to raise_error(ArgumentError)
    end
  end

  context "when one of items does not match" do
    context "when type does not match" do
      it "fails" do
        expect do
          expect(response).to have_jsonapi_resources([
            {
              "type" => "humans",
              "id" => "2"
            }
          ])
        end.to fail_with(/Response does not contain expected resource/)
      end
    end

    context "when id does not match" do
      it "fails" do
        expect do
          expect(response).to have_jsonapi_resources([
            {
              "type" => "dogs",
              "id" => "13"
            }
          ])
        end.to fail_with(/Response does not contain expected resource/)
      end
    end

    context "when one of attributes does not match" do
      it "fails" do
        expect do
          expect(response).to have_jsonapi_resources([
            {
              "type" => "dogs",
              "id" => "2",
              "name" => "Felix",
              "owner" => "Charlie"
            }
          ])
        end.to fail_with(/Response does not contain expected resource/)
      end
    end
  end

  context "when all items match" do
    context "when one item is passed" do
      it "passes" do
        expect(response).to have_jsonapi_resources([
          {
            "type" => "dogs",
            "id" => "2",
            "name" => "Snoopy",
            "owner" => "Charlie"
          }
        ])
      end
    end

    context "when two items are passed" do
      it "passes" do
        expect(response).to have_jsonapi_resources([
          {
            "id" => "2",
            "type" => "dogs",
            "name" => "Snoopy",
            "owner" => "Charlie"
          },
          {
            "id" => "13",
            "type" => "cats",
            "name" => "Felix"
          }
        ])
      end
    end

    context "when symbols are passed" do
      it "passes" do
        expect(response).to have_jsonapi_resources([
          {
            type: "dogs",
            id: "2",
            name: "Snoopy",
            owner: "Charlie"
          }
        ])
      end
    end
  end
end
