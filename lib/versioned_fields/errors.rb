# frozen_string_literal: true

module VersionedFields
  class Error < StandardError; end

  class DuplicatedMigration < Error
    def initialize(version, field_migration)
      @version         = version
      @field_migration = field_migration
    end

    def message
      <<~MESSAGE.strip.tr("\n", ' ')
        #{@field_migration.model_class}##{@field_migration.field_name}
        already has migration with version #{@version} defined.
      MESSAGE
    end
  end

  class MissingFieldVersion < Error
    def initialize(field, model)
      @field = field
      @model = model
    end

    def message
      "Missing version for the field <#{@model}.#{@field}>. "\
        "Please make sure <#{@field}_version> is filled "\
        "for the whole #{@model.class} table."
    end
  end
end
