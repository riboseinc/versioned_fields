# frozen_string_literal: true

module VersionedFields
  class Migrations
    @migrations = {}

    class << self
      attr_accessor :migrations

      def draw_for(model_class, field_name, &block)
        @migrations[model_class] ||= {}
        @migrations[model_class][field_name] ||=
          Migrations::Field.new(model_class, field_name)
        @migrations[model_class][field_name].instance_eval(&block)
      end

      def migration_for(model_class, field_name, version)
        migrations[model_class][field_name].migrations[version]
      end
    end
  end
end
