# frozen_string_literal: true

require 'versioned_fields/version'
require 'versioned_fields/errors'
require 'versioned_fields/migrations'
require 'versioned_fields/migrations/field'

if defined?(::ActiveRecord)
  require 'versioned_fields/adapters/active_record/specify_latest_versions'
  require 'versioned_fields/adapters/active_record/migrate_fields'
  require 'versioned_fields/adapters/active_record'
end

require 'versioned_fields/railtie' if defined?(Rails::VERSION)
