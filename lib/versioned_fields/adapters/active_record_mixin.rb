# frozen_string_literal: true

module VersionedFields
  module Adapters
    module ActiveRecordMixin
      class << self
        private

        def patch_models!
          Migrations.migrations.each do |model_class, migrations|
            model_class.class_eval do
              # include VersionedFields::Adapters::ActiveRecord::MigrateFields
              include VersionedFields::Adapters::ActiveRecord::\
                      SpecifyLatestVersion
            end

            model_class.instance_eval do
              # after_find       :migrate_fields!
              after_initialize :specify_latest_versions!, if: :new_record?
            end
          end
          # TODO
          # model_class.instance_eval do
          #   after_find :migrate_encrypted_fields!
          #   after_initialize :specify_latest_version!, if: :new_record?
          # end
        end

        # def migrate_fields!
        #   Migrations.migrations[self.class].fields do |field|

        #   end
        # end

        # def specify_latest_versions!
        #   Migrations.migrations[self.class].fields do |field|

        #   end
        # end
      end
    end
  end
end
