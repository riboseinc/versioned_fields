# frozen_string_literal: true

module VersionedFields
  class Migrations
    class Field
      attr_reader :model_class, :field_name, :migrations

      def initialize(model_class, field_name)
        @model_class = model_class
        @field_name  = field_name
        @migrations  = {}
      end

      def version(version_id, &block)
        if @migrations.keys.include?(version_id)
          raise VersionedFields::DuplicatedMigration.new(version_id, self)
        end

        @migrations[version_id] = block
      end

      def latest_version
        @migrations.keys.max
      end

      def versions_above(given_version)
        @migrations.keys.sort.select { |ver| ver > given_version }
      end
    end
  end
end
