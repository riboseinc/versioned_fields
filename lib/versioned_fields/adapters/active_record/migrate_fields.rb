# frozen_string_literal: true

module VersionedFields
  module Adapters
    module ActiveRecord
      module MigrateFields
        def specify_latest_version!
          Migrations.migrations[self.class].fields do |field, versions|
            latest_version  = versions.keys.max
            next if public_send("#{field}_version")

            public_send("#{field}_version=", latest_version)
          end
        end
        private :specify_latest_version!
      end
    end
  end
end
