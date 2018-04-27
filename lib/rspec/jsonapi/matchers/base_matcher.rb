module RSpec
  module JsonApi
    module Matchers
      # Basic class for JSON API matchers. Subclasses must implement +verify!+ method
      # that raises Api::ExpectationFailure with meaningful message in case of failure.
      class BaseMatcher
        attr_reader :response, :parsed_response

        # @param response [ActionDispatch::Response]
        #
        # @return [Boolean]
        def matches?(response)
          @response = response
          set_parsed_response!
          validate_schema!
          verify!
          true
        rescue ExpectationFailure => err
          @message = "#{err.message}.\n#{pretty_response}"
          false
        end

        def failure_message
          @message || "expected to #{description}"
        end

        def failure_message_when_negated
          @message || "expected not to #{description}"
        end

        # Default description.
        # E.g. for HaveJsonapiResource => "have jsonapi resource"
        def description
          self.class.name.underscore.humanize.downcase
        end

        private def set_parsed_response!
          @parsed_response = JSON.parse(response.body)
        rescue JSON::ParserError
          raise(ExpectationFailure , "Response contains malformed JSON")
        end

        private def schema
          @schema ||= begin
            parsed_schema = JSON.parse(File.read(File.join(__dir__,"/jsonapi.json")))
            JsonSchema.parse!(parsed_schema).tap do |s|
              s.expand_references!
            end
          end
        rescue JSON::ParserError => error
          raise ExpectationFailure, "JSON Schema is not valid JSON. #{error&.message}"
        rescue JsonSchema::SchemaError => error
          raise ExpectationFailure, "JSON Schema is valid JSON, but is not a valid JSON Schema. #{error&.message}"
        end

        private def validate_schema!
          schema.validate!(parsed_response)
        rescue JsonSchema::Error => error
          msg = "Response does not match JSON API schema. #{error.message}"
          raise(ExpectationFailure, msg)
        end

        private def pretty_response
          if parsed_response
            JSON.pretty_generate(parsed_response)
          else
            response.body
          end
        end
      end
    end
  end
end
