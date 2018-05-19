# frozen_string_literal: true

module VersionedFields
  module Adapters
    module ActiveRecord
      class << self
        # private

        def patch_models!
          Migrations.migrations.each do |model_class, _|
            model_class.class_eval do
              include VersionedFields::Adapters::ActiveRecord::MigrateFields
              include VersionedFields::Adapters::ActiveRecord::\
                      SpecifyLatestVersions
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
