# frozen_string_literal: true

module VersionedFields
  class Error < StandardError; end

  class DuplicatedMigration < Error
    def initialize(version, field_migration)
      @version         = version
      @field_migration = field_migration
    end

    def message
      <<~MESSAGE.strip.gsub("\n", ' ')
        #{@field_migration.model_class}##{@field_migration.field_name}
        already has migration with version #{@version} defined.
      MESSAGE
    end
  end
end
