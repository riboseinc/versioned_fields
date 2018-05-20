# frozen_string_literal: true

RSpec.describe 'Integration specs' do
  before(:all) do
    VersionedFields::Migrations.instance_variable_set(:@migrations, {})
    VersionedFields::Migrations.draw_for(FooModel, :foobar) do
      version 1
      version(2) { |value| "Version 2: #{value}" }
      version(3) { |value| value.gsub('Version 2: ', 'Version 3 - ') }
    end
    VersionedFields::Adapters::ActiveRecord.patch_models!
  end

  context 'when there is existing record with older version' do
    let(:record) { FooModel.create(foobar: 'Some value', foobar_version: 1) }

    it 'migrates the field to the latest version when accessing the record' do
      expect { record.reload }
        .to change { [record.foobar, record.foobar_version] }
        .from(['Some value', 1])
        .to(['Version 3 - Some value', 3])
    end
  end

  context 'when existing record is already the newest version of the field' do
    let(:record) { FooModel.create(foobar: 'Some value', foobar_version: 3) }

    it 'does not change the record' do
      expect { record.reload }
        .not_to change { [record.foobar, record.foobar_version] }
    end
  end

  context 'when existing record does not have a version' do
    before do
      ActiveRecord::Base
        .connection
        .execute(
          "INSERT INTO foo_models (id, foobar) VALUES (99, 'Some value');"
        )
    end

    it 'raises error' do
      expect { FooModel.find(99) }
        .to raise_error(VersionedFields::MissingFieldVersion)
    end
  end

  describe 'new record creation' do
    context 'when foobar_version is not specified' do
      it 'sets versioned field version to the latest version' do
        expect(FooModel.new(foobar: 'Foo').foobar_version).to eq(3)
      end
    end

    context 'when foobar_version is specified' do
      it 'does not change versioned field version' do
        expect(FooModel.new(foobar: 'Foo', foobar_version: 5).foobar_version)
          .to eq(5)
      end
    end
  end
end
