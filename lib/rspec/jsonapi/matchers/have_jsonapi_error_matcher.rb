module RSpec
  module JsonApi
    module Matchers
      class HaveJsonApiErrorMatcher < BaseMatcher
        attr_reader :expected_properties, :errors

        def initialize(expected_properties)
          @expected_properties = expected_properties.stringify_keys
        end

        private def verify!
          set_errors!
          verify_expected_properties!
        end

        private def set_errors!
          if parsed_response["errors"]
            @errors = parsed_response["errors"]
          else
            raise(ExpectationFailure, "Response does not contain \"errors\" item")
          end
        end

        private def verify_expected_properties!
          detected_error = errors.detect do |err|
            expected_properties.all? { |key, val| err[key] == val }
          end
          raise(ExpectationFailure, "Expected to have error that matches #{expected_properties.inspect}") unless detected_error
        end
      end
    end
  end
end
