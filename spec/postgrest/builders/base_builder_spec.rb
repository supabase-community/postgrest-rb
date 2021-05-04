module Postgrest
  RSpec.describe Builders::BaseBuilder do
    describe 'call/execute' do
      let(:http_instance) { double(Postgrest::HTTP) }
      before { allow(http_instance).to receive(:call) }

      subject { described_class.new(http_instance) }

      it { expect(subject).to respond_to(:call) }
      it { expect(subject).to respond_to(:execute) }

      context 'when trigger' do
        it 'calls the #call method' do
          subject.call

          expect(http_instance).to have_received(:call)
        end

        it 'executes the #call method' do
          subject.execute

          expect(http_instance).to have_received(:call)
        end
      end
    end
  end
end
