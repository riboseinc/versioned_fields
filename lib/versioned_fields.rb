# frozen_string_literal: true

require 'pry'

require 'versioned_fields/version'
require 'versioned_fields/errors'
require 'versioned_fields/migrations'
require 'versioned_fields/migrations/field'

if defined?(::ActiveRecord)
  require 'versioned_fields/adapters/active_record/specify_latest_version'
  require 'versioned_fields/adapters/active_record_mixin'
end
