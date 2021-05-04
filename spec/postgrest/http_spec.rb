RSpec.describe Postgrest::HTTP do
  let(:uri) { URI('http://google.com') }

  describe 'constants' do
    it { expect(described_class.const_defined?('USER_AGENT')).to eq(true) }
    it { expect(described_class.const_defined?('METHODS')).to eq(true) }
    it { expect(described_class.const_defined?('RESPONSES')).to eq(true) }
  end

  describe 'attributes' do
    subject { described_class.new(uri: uri)}

    it { expect(subject).to respond_to(:uri)}
    it { expect(subject).to respond_to(:query)}
    it { expect(subject).to respond_to(:body)}
    it { expect(subject).to respond_to(:headers)}
    it { expect(subject).to respond_to(:http_method)}
    it { expect(subject).to respond_to(:response)}
    it { expect(subject).to respond_to(:request)}
  end

  describe '#create_request' do
    subject { described_class.new(uri: uri, http_method: http_method, headers: { foo: 123 })}

    context 'when request is a GET' do
      let(:http_method) { :get }
      let(:result) { subject.send(:create_request) }

      it { expect(result).to be_a(Net::HTTP::Get) }
      it { expect(result.uri).to eq(uri) }
      it { expect(result['foo']).to eq('123') }
    end

    context 'when request is a POST' do
      let(:http_method) { :post }
      let(:result) { subject.send(:create_request) }

      it { expect(result).to be_a(Net::HTTP::Post) }
      it { expect(result.uri).to eq(uri) }
      it { expect(result['foo']).to eq('123') }
    end

    context 'when request is a PUT' do
      let(:http_method) { :patch }
      let(:result) { subject.send(:create_request) }

      it { expect(result).to be_a(Net::HTTP::Patch) }
      it { expect(result.uri).to eq(uri) }
      it { expect(result['foo']).to eq('123') }
    end

    context 'when request is a DELETE' do
      let(:http_method) { :delete }
      let(:result) { subject.send(:create_request) }

      it { expect(result).to be_a(Net::HTTP::Delete) }
      it { expect(result.uri).to eq(uri) }
      it { expect(result['foo']).to eq('123') }
    end
  end

  describe '#update_query_params' do
    subject { described_class.new(uri: uri, query: { foo: 123 })}

    context 'when param is a Hash' do
      it "change the request's query params" do
        subject.update_query_params(foo: 321, bar: 321)

        expect(subject.uri.query).to eq('foo=321&bar=321')
      end
    end

    context 'when params is an Array' do
      it "change the request's query params" do
        subject.update_query_params([:foo, :bar])

        expect(subject.uri.query).to eq('foo&bar')
      end
    end

    context 'when params is a String' do
      it "change the request's query params" do
        subject.update_query_params('foo')

        expect(subject.uri.query).to eq('foo=123')
      end
    end
  end

  xdescribe '#call' do
  end

  describe '#add_headers' do
    subject { described_class.new(uri: uri, http_method: :get, headers: { foo: 123 })}

    before do
      request = subject.instance_variable_set(:@request, described_class::METHODS[:get].new(uri))
      subject.send(:add_headers, request)
    end

    it { expect(subject.request['foo']).to eq('123') }
    it { expect(subject.request['user-agent']).to eq(described_class::USER_AGENT) }
  end

  describe '#use_ssl?' do
    context 'when URI use HTTP' do
      subject { described_class.new(uri: uri, http_method: :get)}

      it { expect(subject.send(:use_ssl?)).to eq(false) }
    end

    context 'when URI use HTTPS' do
      let(:uri) { URI('https://google.com') }
      subject { described_class.new(uri: uri, http_method: :get)}

      it { expect(subject.send(:use_ssl?)).to eq(true) }
    end
  end

  describe '#valid_http_method?' do
    context 'when method is valid' do
      subject { described_class.new(uri: uri, http_method: :get)}

      it { expect(subject.send(:valid_http_method?)).to eq(true) }
    end

    context 'when method is invalid' do
      subject { described_class.new(uri: uri, http_method: :foo)}

      it { expect(subject.send(:valid_http_method?)).to eq(false) }
    end
  end
end
