module Postgrest
  RSpec.describe Builders::FilterBuilder do
    let(:uri) { URI('https://postgrest_server.com?select=*') }
    let(:http_instance) { Postgrest::HTTP.new(uri: uri) }
    subject { described_class.new(http_instance) }

    describe 'attributes' do
      it 'is expected to assing inverse_next' do
        expect(subject.instance_variable_get(:@inverse_next)).to be_falsy
      end

      it 'is expected to assing http instance' do
        expect(subject.instance_variable_get(:@http)).to eq(http_instance)
      end
    end

    describe 'methods' do
      describe '#eq' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.eq(id: 1).http.uri.query).to eq("id=not.eq.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.eq(id: 1).http.uri.query).to eq("id=eq.1")
          end
        end
      end

      describe '#neq' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.neq(id: 1).http.uri.query).to eq("id=not.neq.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.neq(id: 1).http.uri.query).to eq("id=neq.1")
          end
        end
      end

      describe '#gt' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.gt(id: 1).http.uri.query).to eq("id=not.gt.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.gt(id: 1).http.uri.query).to eq("id=gt.1")
          end
        end
      end

      describe '#gte' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.gte(id: 1).http.uri.query).to eq("id=not.gte.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.gte(id: 1).http.uri.query).to eq("id=gte.1")
          end
        end
      end

      describe '#lt' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.lt(id: 1).http.uri.query).to eq("id=not.lt.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.lt(id: 1).http.uri.query).to eq("id=lt.1")
          end
        end
      end

      describe '#lte' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.lte(id: 1).http.uri.query).to eq("id=not.lte.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.lte(id: 1).http.uri.query).to eq("id=lte.1")
          end
        end
      end

      describe '#like' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.like(id: 1).http.uri.query).to eq("id=not.like.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.like(id: 1).http.uri.query).to eq("id=like.1")
          end
        end
      end

      describe '#ilike' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.ilike(id: 1).http.uri.query).to eq("id=not.ilike.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.ilike(id: 1).http.uri.query).to eq("id=ilike.1")
          end
        end
      end

      describe '#fts' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.fts(id: 1).http.uri.query).to eq("id=not.fts.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.fts(id: 1).http.uri.query).to eq("id=fts.1")
          end
        end
      end

      describe '#plfts' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.plfts(id: 1).http.uri.query).to eq("id=not.plfts.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.plfts(id: 1).http.uri.query).to eq("id=plfts.1")
          end
        end
      end

      describe '#phfts' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.phfts(id: 1).http.uri.query).to eq("id=not.phfts.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.phfts(id: 1).http.uri.query).to eq("id=phfts.1")
          end
        end
      end

      describe '#wfts' do
        context 'when call not before' do
          it 'changes the URI' do
            expect(subject.not.wfts(id: 1).http.uri.query).to eq("id=not.wfts.1")
          end
        end

        context 'when call it directly' do
          it 'changes the URI' do
            expect(subject.wfts(id: 1).http.uri.query).to eq("id=wfts.1")
          end
        end
      end

      describe '#not' do
        context 'when previous command was not a #not' do
          it 'changes the @inverse_next instance variable' do
            subject.not
            expect(subject.instance_variable_get(:@inverse_next)).to eq(true)
          end
        end

        context 'when previous command was a #not' do
          it 'changes the @inverse_next instance variable' do
            subject.not.not
            expect(subject.instance_variable_get(:@inverse_next)).to eq(false)
          end
        end
      end

      describe '#query' do
        context 'delegates the method to the http instance' do
          it 'changes the @inverse_next instance variable' do
            expect(subject.query).to eq(http_instance.uri.query)
          end
        end
      end
    end
  end
end
