# frozen_string_literal: true

module VersionedFields
  class Migrations
    class Config
      attr_reader :modules

      def initialize
        @modules = []
      end

      def include(module_name)
        @modules << module_name unless @modules.include?(module_name)
      end
    end
  end
end
