# frozen_string_literal: true

RSpec.describe VersionedFields::Migrations do
  let(:model_class) { Class.new }
  let(:model_field) { :foobar }
  let(:another_class) { Class.new }
  let(:another_field) { :pewpew }

  describe '#draw_for' do
    subject do
      described_class.draw_for(model_class, model_field) do
        version(2) { |value| value * value }
      end
    end

    it 'stores migration in Migrations::Field class' do
      expect { subject }
        .to change { described_class.migrations.dig(model_class, model_field) }
        .from(nil).to(instance_of(VersionedFields::Migrations::Field))
    end

    it 'executes block in a Migrations::Field context' do
      subject
      migration =
        described_class.migrations.dig(model_class, model_field).migrations[2]
      expect(migration).to be_a(Proc)
      expect(migration.call(3)).to eq(9)
    end
  end

  describe '#migration_for' do
    subject do
      described_class.draw_for(model_class, model_field) do
        version(2) { |value| value * value }
      end
      described_class.draw_for(another_class, another_field) do
        version(1)
        version(2) { |value| "This is #{value}" }
        version(3) { |value| value + '.' }
      end
    end

    it 'returns proc of corresponding migration' do
      subject
      migration = described_class.migration_for(another_class, another_field, 3)
      expect(migration.call('Hello')).to eq('Hello.')
    end
  end
end
