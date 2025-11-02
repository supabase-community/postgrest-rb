module Postgrest
  RSpec.describe Builders::QueryBuilder do
    let(:url) { 'https://postgrest_server.com' }
    let(:read_profile) { { :'Accept-Profile' => 'public' } }
    let(:write_profile) { { :'Content-Profile' => 'public' } }
    subject { described_class.new(url: url, headers: {}, schema: 'public') }

    describe 'attributes' do
      it { is_expected.to respond_to(:uri) }
      it { is_expected.to respond_to(:headers) }
      it { is_expected.to respond_to(:schema) }
    end

    describe '#select' do
      context 'common scenario' do
        let(:instance) { subject.select }

        it { expect(instance).to be_a(Builders::FilterBuilder) }
        it { expect(instance.http.headers).to eq(read_profile) }
      end

      context 'when passing extra headers' do
        it 'merges the headers' do
          instance = subject.select(extra_headers: { :'Accept-Profile' => 'other', foo: 123 })
          expect(instance.http.headers).to eq({ :'Accept-Profile' => 'other', foo: 123 })
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
        it { expect(instance.http.headers).to eq(write_profile.merge({ Prefer: 'return=representation' })) }
      end
    end

    describe '#upsert' do
      context 'common scenario' do
        let(:instance) { subject.upsert({ name: 'John', age: 32 }) }

        it { expect(instance).to be_a(Builders::BaseBuilder) }
        it { expect(instance.http.body).to eq({ name: 'John', age: 32 }) }
        it { expect(instance.http.headers).to eq(write_profile.merge({ Prefer: 'return=representation,resolution=merge-duplicates' })) }
      end

      context 'with custom headers' do
        describe 'sets the headers' do
          let(:instance) { subject.upsert({ name: 'John', age: 32 }, extra_headers: { :'Content-Profile' => 'other', foo: 123 }) }

          it { expect(instance).to be_a(Builders::BaseBuilder) }
          it { expect(instance.http.headers).to eq({ :'Content-Profile' => 'other', foo: 123, Prefer: 'return=representation,resolution=merge-duplicates' }) }
        end
      end
    end

    describe '#update' do
      context 'common scenario' do
        let(:instance) { subject.update({ name: 'John', age: 32 }) }

        it { expect(instance).to be_a(Builders::FilterBuilder) }
        it { expect(instance.http.body).to eq({ name: 'John', age: 32 }) }
        it { expect(instance.http.headers).to eq(write_profile.merge({ Prefer: 'return=representation' })) }
      end

      context 'with custom headers' do
        describe 'sets the headers' do
          let(:instance) { subject.update({ name: 'John', age: 32 }, extra_headers: { :'Content-Profile' => 'other', foo: 123 }) }

          it { expect(instance).to be_a(Builders::FilterBuilder) }
          it { expect(instance.http.headers).to eq({ :'Content-Profile' => 'other', foo: 123, Prefer: 'return=representation' }) }
        end
      end
    end

    describe '#delete' do
      context 'with custom headers' do
        describe 'sets the headers' do
          let(:instance) { subject.delete(extra_headers: { foo: 123 }) }

          it { expect(instance).to be_a(Builders::FilterBuilder) }
          it { expect(instance.http.headers).to eq(write_profile.merge({ foo: 123, Prefer: 'return=representation' })) }
        end
      end

      context 'common scenario' do
        let(:instance) { subject.delete }

        it { expect(instance).to be_a(Builders::FilterBuilder) }
        it { expect(instance.http.headers).to eq(write_profile.merge({ Prefer: 'return=representation' })) }
      end
    end
  end
end
