# frozen_string_literal: true

module VersionedFields
  class Migrations
    class << self
      attr_accessor :migrations, :latest_versions

      def draw_for(model_class, field_name, &block)
        @migrations ||= {}
        @migrations[model_class] ||= {}
        @migrations[model_class][field_name] ||=
          Migrations::Field.new(model_class, field_name)
        @migrations[model_class][field_name].instance_eval(&block)
      end
    end
  end
end
