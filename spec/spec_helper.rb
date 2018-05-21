# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'active_record'
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)
ActiveRecord::Migration.verbose = false

ActiveRecord::Base.connection.create_table(:foo_models) do |t|
  t.string  :foobar
  t.integer :foobar_version
end
class FooModel < ActiveRecord::Base; end

require './lib/versioned_fields'
