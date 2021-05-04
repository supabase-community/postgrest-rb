RSpec.describe Postgrest::Client do
  describe 'constants' do
    it { expect(described_class.const_defined?('DEFAULT_SCHEMA')).to eq(true) }
  end

  describe 'attributes' do
    subject { described_class.new(url: '') }

    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:headers) }
    it { is_expected.to respond_to(:schema) }
  end

  describe '#from' do
    subject { described_class.new(url: '') }

    context 'when no table provided' do
      it 'raises MissingTableError' do
        expect { subject.from(nil) }.to raise_error(Postgrest::MissingTableError)
      end
    end

    context 'when table is an empty string' do
      it 'raises MissingTableError' do
        expect { subject.from('') }.to raise_error(Postgrest::MissingTableError)
      end
    end

    context 'when table was provided' do
      it 'returns a Builders::QueryBuilder instance' do
        expect(subject.from('todos')).to be_a(Postgrest::Builders::QueryBuilder)
      end
    end
  end
end
