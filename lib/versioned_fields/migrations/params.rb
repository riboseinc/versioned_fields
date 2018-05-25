# frozen_string_literal: true

module VersionedFields
  class Migrations
    class Params
      def initialize(**options)
        @data = OpenStruct.new(options)
      end

      def method_missing(method_name, *args, &block)
        @data.public_send(method_name) || super
      end

      def respond_to_missing?(method_name, _include_private)
        !@data.public_send(method_name).nil?
      end
    end
  end
end
