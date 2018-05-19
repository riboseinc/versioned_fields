# frozen_string_literal: true

module VersionedFields
  module Adapters
    module ActiveRecord
      module SpecifyLatestVersions
        # If foo_version field is missing, fill it with latest version
        def specify_latest_versions!
          Migrations.migrations[self.class].each do |field, migration_data|
            latest_version = migration_data.latest_version
            next if public_send("#{field}_version")

            public_send("#{field}_version=", latest_version)
          end
        end
        private :specify_latest_versions!
      end
    end
  end
end
