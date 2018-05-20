# frozen_string_literal: true

RSpec.describe VersionedFields::Adapters::ActiveRecord do
  describe '#patch_models!' do
    before(:all) do
      VersionedFields::Migrations.instance_variable_set(:@migrations, {})
      VersionedFields::Migrations.draw_for(FooModel, :foobar) do
        version(1)
      end
    end

    it 'includes MigrateFields & SpecifyLatestVersions modules' do
      modules = [
        VersionedFields::Adapters::ActiveRecord::MigrateFields,
        VersionedFields::Adapters::ActiveRecord::SpecifyLatestVersions
      ]
      described_class.patch_models!
      expect(modules & FooModel.included_modules).to eq(modules)
    end

    describe 'callbacks definition' do
      it 'defines `after_initialize` callback with :specify_latest_versions!' do
        expect_any_instance_of(FooModel)
          .to receive(:specify_latest_versions!).exactly(:once)
        FooModel.new
      end

      it 'defines `after_find` callback with :migrate_fields! method' do
        record = FooModel.create
        expect_any_instance_of(FooModel)
          .to receive(:migrate_fields!).exactly(:once)
        FooModel.find(record.id)
      end
    end
  end
end
