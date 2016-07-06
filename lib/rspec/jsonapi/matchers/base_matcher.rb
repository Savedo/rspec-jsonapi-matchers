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

        private def validate_schema!
          JSON::Validator.validate!(JSONAPI_SCHEMA_PATH, parsed_response)
        rescue JSON::Schema::ValidationError => err
          msg = "Response does not match JSON API schema. #{err.message}"
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
