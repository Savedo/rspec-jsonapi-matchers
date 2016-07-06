module RSpec
  module JsonApi
    module Matchers
      class Resource
        attr_reader :type, :id, :attributes

        def initialize(type = nil, id = nil, attributes = {})
          @type = type
          @id = id
          @attributes = attributes
        end
      end
    end
  end
end
