# frozen_string_literal: true

module VersionedFields
  module Adapters
    module ActiveRecord
      class << self
        def patch_models!
          Migrations.migrations.each do |model_class, fields|
            # Mandatory modules
            model_class.class_eval do
              include VersionedFields::Adapters::ActiveRecord::MigrateFields
              include VersionedFields::Adapters::ActiveRecord::\
                      SpecifyLatestVersions
            end

            # Custom modules/concerns implementing migration helper methods
            fields.each do |_field, migration|
              migration.config.modules.each do |module_name|
                model_class.class_eval { include module_name }
              end
            end

            model_class.instance_eval do
              after_find       :migrate_fields!
              after_initialize :specify_latest_versions!, if: :new_record?
            end
          end
        end
      end
    end
  end
end
