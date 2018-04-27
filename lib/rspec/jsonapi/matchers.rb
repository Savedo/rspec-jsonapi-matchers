require "active_support"
require "active_support/core_ext/hash"
require "json_schema"

require "rspec/jsonapi/matchers/version"
require "rspec/jsonapi/matchers/resource"
require "rspec/jsonapi/matchers/base_matcher"
require "rspec/jsonapi/matchers/have_jsonapi_error_matcher"
require "rspec/jsonapi/matchers/have_jsonapi_resource_matcher"
require "rspec/jsonapi/matchers/have_jsonapi_resources_matcher"

module RSpec
  module JsonApi
    module Matchers
      class ExpectationFailure < ::StandardError; end

      # Verify that response contains error in JSON API format with given
      # code and title.
      # For more info please check: http://jsonapi.org/format/1.0/#error-objects
      #
      # @example
      #   expect(response).to have_jsonapi_error(
      #     code: "invalid_schema",
      #     title: "attributes are missing"
      #   )
      #
      # @param expected_properties [Hash]
      def have_jsonapi_error(expected_properties)
        HaveJsonApiErrorMatcher.new(expected_properties)
      end

      # Verify that response contains resource with given type, id and attributes
      # in JSON API format.
      # For more info please check: http://jsonapi.org/format/#document-resource-objects
      #
      # @example
      #   expect(response).to have_jsonapi_error("customers", 113", first_name: "John")
      #
      # @param attrs [Hash]
      def have_jsonapi_resource(attrs = {})
        HaveJsonApiResourceMatcher.new(attrs)
      end

      # Verify that response contains JSON API resources with parameters.
      #
      # @example
      #   expect(response).to have_jsonapi_resources([
      #     {
      #       "id" => "2",
      #       "type" => "dogs",
      #       "name" => "Snoopy",
      #       "owner" => "Charlie"
      #     },
      #     {
      #       "id" => "13",
      #       "type" => "cats",
      #       "name" => "Felix"
      #     }
      #   ])
      # @param array_of_expected_attrs [Array<Hash>]
      def have_jsonapi_resources(array_of_expected_attrs)
        HaveJsonApiResourcesMatcher.new(array_of_expected_attrs)
      end
    end
  end
end
