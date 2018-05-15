# frozen_string_literal: true

require 'simplecov'

SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'active_record'

ActiveRecord::Base
  .establish_connection(adapter: 'sqlite3', database: ':memory:')
