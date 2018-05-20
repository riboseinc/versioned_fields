# frozen_string_literal: true

RSpec.describe VersionedFields::Migrations::Field do
  let(:model_class) { Class.new }
  let(:field_name)  { 'foobar' }

  subject { described_class.new(model_class, field_name) }

  describe '#version' do
    it 'stores migration proc in the list of migrations' do
      expect { subject.version(2) { |value| value * 2 } }
        .to change { subject.migrations[2] }
        .from(nil)
    end

    it 'stores proper migration proc in the list of migrations' do
      subject.version(2) { |value| value * 2 }
      expect(subject.migrations[2].call(5)).to eq(10)
    end

    context 'when migration for that version is already defined' do
      before { subject.version(2) }

      it 'raises error' do
        expect { subject.version(2) }
          .to raise_error(VersionedFields::DuplicatedMigration)
      end
    end
  end

  describe '#latest_version' do
    before do
      [3, 5, 2].each do |i|
        subject.version(i) { |_| puts "Just a proc for version #{i}" }
      end
    end

    it 'returns correct latest version of the field' do
      expect(subject.latest_version).to eq(5)
    end
  end

  describe '#versions_above' do
    before do
      [2, 5, 4, 7, 1, 9, 6].each do |i|
        subject.version(i) { |_| puts "Just a proc for version #{i}" }
      end
    end

    it 'returns a list of versions older than the provided one' do
      expect(subject.versions_above(4)).to eq([5, 6, 7, 9])
    end
  end
end
