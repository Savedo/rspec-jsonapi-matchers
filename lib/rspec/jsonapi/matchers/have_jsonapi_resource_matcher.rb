module RSpec
  module JsonApi
    module Matchers
      class HaveJsonApiResourceMatcher < BaseMatcher
        attr_reader :data, :expected_resource

        def initialize(attributes)
          attrs = attributes.stringify_keys
          type = attrs.delete("type")
          id = attrs.delete("id")
          @expected_resource = Resource.new(type, id, attrs)
        end

        private def verify!
          set_data!
          actual_resource = Resource.new(data["type"], data["id"] , data["attributes"])
          verify_resource!(expected_resource, actual_resource)
        end

        private def set_data!
          if parsed_response["data"]
            @data = parsed_response["data"]
          else
            raise(ExpectationFailure , "Response does not contain \"data\" property")
          end
        end

        private def verify_resource!(expected_resource, actual_resource)
          verify_type!(expected_resource, actual_resource)
          verify_id!(expected_resource, actual_resource)
          verify_attrs!(expected_resource, actual_resource)
        end

        private def verify_type!(expected_resource, actual_resource)
          return unless expected_resource.type.present?
          return if actual_resource.type.to_s == expected_resource.type.to_s
          raise(ExpectationFailure , "Expected resource type to be #{expected_resource.type.inspect}, but got #{actual_resource.type.inspect}")
        end

        private def verify_id!(expected_resource, actual_resource)
          return unless expected_resource.id.present?
          return if actual_resource.id.to_s == expected_resource.id.to_s
          raise(ExpectationFailure , "Expected resource id to be #{expected_resource.id.inspect}, but got #{actual_resource.id.inspect}")
        end

        private def verify_attrs!(expected_resource, actual_resource)
          return unless expected_resource.attributes.present?
          raise(ExpectationFailure, "attributes are not present in the response") unless actual_resource.attributes

          expected_resource.attributes.each do |attr, expected_value|
            actual_value = actual_resource.attributes[attr]
            if actual_value != expected_value
              raise(ExpectationFailure, "Expected attribute #{attr.inspect} to be #{expected_value.inspect}, but got #{actual_value.inspect}")
            end
          end
        end
      end
    end
  end
end
