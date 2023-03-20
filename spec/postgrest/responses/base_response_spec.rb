module Postgrest
  RSpec.describe Responses::BaseResponse do
    let(:uri) { URI('https://google.com?eq=123') }
    let(:request) { Net::HTTP::Get.new(uri) }
    let(:response_klass) { Net::HTTPSuccess }
    let(:response) { double(response_klass) }
    let(:response_body) { { success: true }.to_json }

    subject { described_class.new(request, response) }

    before do
      allow(response).to receive(:is_a?).and_return(true)
      allow(response).to receive(:body).and_return(response_body)
      allow(response).to receive(:[]).and_return({})
    end

    describe '#error' do
      context 'when response was a failure' do
        let(:response_klass) { Net::HTTPUnprocessableEntity }
        before { allow(response).to receive(:is_a?).and_return(false) }

        it { expect(subject.error).to eq(true) }
      end

      context 'when response was success' do
        subject { described_class.new(request, response) }

        it { expect(subject.error).to eq(false) }
      end
    end

    describe '#count' do
      context 'when response was success' do
        subject { described_class.new(request, response) }
        let(:response_body) { [{ a: 1 }, { a: 2 }].to_json }

        it { expect(subject.count).to eq(2) }
      end
    end

    describe '#status' do
      context 'when response was success' do
        subject { described_class.new(request, response) }
        before { allow(response).to receive(:code).and_return('200') }

        it { expect(subject.status).to eq(200) }
      end

      context 'when response was a failure' do
        before { allow(response).to receive(:code).and_return('422') }

        it { expect(subject.status).to eq(422) }
      end
    end

    describe '#status_text' do
      context 'when response was success' do
        subject { described_class.new(request, response) }
        before { allow(response).to receive(:message).and_return('OK') }

        it { expect(subject.status_text).to eq('OK') }
      end

      context 'when response was a failure' do
        before { allow(response).to receive(:message).and_return('Bad Request') }

        it { expect(subject.status_text).to eq('Bad Request') }
      end
    end

    describe '#data' do
      context 'when response was success' do
        subject { described_class.new(request, response) }
        let(:response_body) { { success: true, foo: :bar }.to_json }
        it { expect(subject.data).to eq({ 'success' => true, 'foo' => 'bar' }) }
      end

      context 'when response was a failure' do
        let(:response_body) { '' }
        subject { described_class.new(request, response) }

        it { expect(subject.data).to eq({}) }
      end

      context 'when response body was compressed' do
        subject { described_class.new(request, response) }

        let(:response_body) do
          data = { success: true, foo: :bar }.to_json
          gz = Zlib::GzipWriter.new(StringIO.new)
          gz << data
          gz.close.string
        end

        before do
          allow(response).to receive(:[]).with('content-encoding').and_return('gzip')
          allow(response).to receive(:[]).with('content-range').and_return('0-999/*')
        end

        it 'decompresses the body' do
          expect(subject.data).to eq({ 'success' => true, 'foo' => 'bar' })
        end
      end
    end

    describe '#params' do
      context 'when request was success' do
        subject { described_class.new(request, response) }

        it { expect(subject.params).to eq({ body: {}, query: 'eq=123' }) }
      end
    end
  end
end
