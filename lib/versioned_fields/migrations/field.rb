# frozen_string_literal: true

module VersionedFields
  class Migrations
    class Field
      attr_accessor :config
      attr_reader :model_class, :field_name, :migrations

      def initialize(model_class, field_name)
        @config      = Config.new
        @field_name  = field_name
        @model_class = model_class
        @migrations  = {}
      end

      def version(version_id, &block)
        if @migrations.key?(version_id)
          raise VersionedFields::DuplicatedMigration.new(version_id, self)
        end

        @migrations[version_id] = block
      end

      def latest_version
        @migrations.keys.max
      end

      def versions_above(given_version)
        @migrations.keys.select { |ver| ver > given_version }.sort
      end
    end
  end
end
