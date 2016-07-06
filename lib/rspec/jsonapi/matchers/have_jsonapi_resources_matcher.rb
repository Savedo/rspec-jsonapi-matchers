module RSpec
  module JsonApi
    module Matchers
      class HaveJsonApiResourcesMatcher < HaveJsonApiResourceMatcher
        attr_reader :array_of_expected_attrs

        def initialize(array_of_expected_attrs)
          if array_of_expected_attrs.is_a?(Array)
            @array_of_expected_attrs = array_of_expected_attrs
          else
            raise(ArgumentError, "have_jsonapi_resources matcher accepts Array of Hashes, got #{array_of_expected_attrs.inspect}")
          end
        end

        def verify!
          set_data!
          array_of_expected_attrs.each do |original_attrs|
            attrs = original_attrs.stringify_keys
            type = attrs.delete("type")
            id = attrs.delete("id")
            verify_expected_resource!(type, id, attrs)
          end
        end

        private def verify_expected_resource!(expected_type, expected_id, expected_attrs)
          expected_resource = Resource.new(expected_type, expected_id, expected_attrs)
          match = data.any? do |actual_resource_data|
            match_resource?(expected_resource, actual_resource_data)
          end
          return if match

          raise(ExpectationFailure,
            "Response does not contain expected resource with type=#{expected_type.inspect}, "\
            "id=#{expected_id}, attributes=#{expected_attrs.inspect}"
          )
        end

        private def match_resource?(expected_resource, actual_data)
          actual_resource = Resource.new(actual_data["type"], actual_data["id"], actual_data["attributes"])
          verify_resource!(expected_resource, actual_resource)
          true
        rescue ExpectationFailure
          false
        end
      end
    end
  end
end
