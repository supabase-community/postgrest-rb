module Postgrest
  RSpec.describe Builders::QueryBuilder do
    let(:url) { 'https://postgrest_server.com' }
    subject { described_class.new(url: url, headers: {}, schema: 'public') }

    describe 'attributes' do
      it { is_expected.to respond_to(:uri) }
      it { is_expected.to respond_to(:headers) }
      it { is_expected.to respond_to(:schema) }
    end

    describe '#select' do
      context 'when passing extra headers' do
        it 'merges the headers' do
          instance = subject.select(extra_headers: { foo: 123 })
          expect(instance.http.headers).to eq({ foo: 123 })
        end
      end

      context 'when not passing extra headers' do
        context 'when passing some custom values' do
          it 'returns an FilterBuilder instance' do
            instance = subject.select(:name, :age)
            expect(instance).to be_a(Builders::FilterBuilder)
            expect(instance.query).to eq('select=name,age')
          end
        end

        it 'returns an FilterBuilder instance' do
          instance = subject.select
          expect(instance).to be_a(Builders::FilterBuilder)
          expect(instance.query).to eq('select=*')
        end
      end
    end

    describe '#insert' do
      context 'common scenario' do
        let(:instance) { subject.insert({ name: 'John', age: 32 }) }

        it { expect(instance).to be_a(Builders::BaseBuilder) }
        it { expect(instance.http.body).to eq({ name: 'John', age: 32 }) }
        it { expect(instance.http.headers).to eq({ Prefer: 'return=representation' }) }
      end
    end

    describe '#upsert' do
      context 'common scenario' do
        let(:instance) { subject.upsert({ name: 'John', age: 32 }) }

        it { expect(instance).to be_a(Builders::BaseBuilder) }
        it { expect(instance.http.body).to eq({ name: 'John', age: 32 }) }
        it { expect(instance.http.headers).to eq({ Prefer: 'return=representation,resolution=merge-duplicates' }) }
      end
    end

    describe '#update' do
      context 'common scenario' do
        let(:instance) { subject.update({ name: 'John', age: 32 }) }

        it { expect(instance).to be_a(Builders::FilterBuilder) }
        it { expect(instance.http.body).to eq({ name: 'John', age: 32 }) }
        it { expect(instance.http.headers).to eq({ Prefer: 'return=representation' }) }
      end
    end

    describe '#delete' do
      context 'with custom headers' do
        describe 'sets the headers' do
          let(:instance) { subject.delete(extra_headers: { foo: 123 }) }

          it { expect(instance).to be_a(Builders::FilterBuilder) }
          it { expect(instance.http.headers).to eq({ Prefer: 'return=representation', foo: 123 }) }
        end
      end

      context 'common scenario' do
        let(:instance) { subject.delete }

        it { expect(instance).to be_a(Builders::FilterBuilder) }
        it { expect(instance.http.headers).to eq({ Prefer: 'return=representation' }) }
      end
    end
  end
end
