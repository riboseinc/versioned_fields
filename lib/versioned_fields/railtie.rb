# frozen_string_literal: true

module VersionedFields
  class Railtie < Rails::Railtie
    initializer "versioned_fields_railtie.configure_rails_initialization" do
      Dir["#{Rails.root}/db/migrate_versioned_fields/**/*.rb"].each do |file|
        require file
      end
      VersionedFields::Adapters::ActiveRecord.patch_models!
      # some initialization behavior
    end
  end
end
