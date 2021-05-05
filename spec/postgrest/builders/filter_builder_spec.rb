module Postgrest
  RSpec.describe Builders::FilterBuilder do
    let(:uri) { URI('https://postgrest_server.com') }
    let(:http_instance) { Postgrest::HTTP.new(uri: uri, query: { select: '*' }) }
    subject { described_class.new(http_instance) }

    describe 'constants' do
      it { expect(described_class.const_defined?('SIMPLE_MATCHERS')).to eq(true) }
      it { expect(described_class.const_defined?('RANGE_MATCHERS')).to eq(true) }
    end

    describe 'before execute hooks defined' do
      it { expect(described_class.before_execute_hooks).to eq([:set_limit, :set_offset, :update_http_instance])}
    end

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
          it 'updates the query params' do
            expect(subject.not.eq(id: 1).decoded_query).to eq({ "id" => "not.eq.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.eq(id: 1).decoded_query).to eq({ "id" => "eq.1", "select" => "*" })
          end
        end
      end

      describe '#neq' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.neq(id: 1).decoded_query).to eq({ "id" => "not.neq.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.neq(id: 1).decoded_query).to eq({ "id" => "neq.1", "select" => "*" })
          end
        end
      end

      describe '#gt' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.gt(id: 1).decoded_query).to eq({ "id" => "not.gt.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.gt(id: 1).decoded_query).to eq({ "id" => "gt.1", "select" => "*" })
          end
        end
      end

      describe '#gte' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.gte(id: 1).decoded_query).to eq({ "id" => "not.gte.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.gte(id: 1).decoded_query).to eq({ "id" => "gte.1", "select" => "*" })
          end
        end
      end

      describe '#lt' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.lt(id: 1).decoded_query).to eq({ "id" => "not.lt.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.lt(id: 1).decoded_query).to eq({ "id" => "lt.1", "select" => "*" })
          end
        end
      end

      describe '#lte' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.lte(id: 1).decoded_query).to eq({ "id" => "not.lte.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.lte(id: 1).decoded_query).to eq({ "id" => "lte.1", "select" => "*" })
          end
        end
      end

      describe '#like' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.like(id: 1).decoded_query).to eq({ "id" => "not.like.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.like(id: 1).decoded_query).to eq({ "id" => "like.1", "select" => "*" })
          end
        end
      end

      describe '#ilike' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.ilike(id: 1).decoded_query).to eq({ "id" => "not.ilike.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.ilike(id: 1).decoded_query).to eq({ "id" => "ilike.1", "select" => "*" })
          end
        end
      end

      describe '#fts' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.fts(id: 1).decoded_query).to eq({ "id" => "not.fts.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.fts(id: 1).decoded_query).to eq({ "id" => "fts.1", "select" => "*" })
          end
        end
      end

      describe '#plfts' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.plfts(id: 1).decoded_query).to eq({ "id" => "not.plfts.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.plfts(id: 1).decoded_query).to eq({ "id" => "plfts.1", "select" => "*" })
          end
        end
      end

      describe '#phfts' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.phfts(id: 1).decoded_query).to eq({ "id" => "not.phfts.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.phfts(id: 1).decoded_query).to eq({ "id" => "phfts.1", "select" => "*" })
          end
        end
      end

      describe '#wfts' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.wfts(id: 1).decoded_query).to eq({ "id" => "not.wfts.1", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.wfts(id: 1).decoded_query).to eq({ "id" => "wfts.1", "select" => "*" })
          end
        end
      end

      describe '#in' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.in(id: [1, 2]).decoded_query).to eq({ "id" => "not.in.(1,2)", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.in(id: [1, 2]).decoded_query).to eq({ "id" => "in.(1,2)", "select" => "*" })
          end
        end
      end

      describe '#sl' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.sl(id: [1, 2]).decoded_query).to eq({ "id" => "range=not.sl.(1,2)", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.sl(id: [1, 2]).decoded_query).to eq({ "id" => "range=sl.(1,2)", "select" => "*" })
          end
        end
      end

      describe '#sr' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.sr(id: [1, 2]).decoded_query).to eq({ "id" => "range=not.sr.(1,2)", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.sr(id: [1, 2]).decoded_query).to eq({ "id" => "range=sr.(1,2)", "select" => "*" })
          end
        end
      end

      describe '#nxr' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.nxr(id: [1, 2]).decoded_query).to eq({ "id" => "range=not.nxr.(1,2)", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.nxr(id: [1, 2]).decoded_query).to eq({ "id" => "range=nxr.(1,2)", "select" => "*" })
          end
        end
      end

      describe '#nxl' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.nxl(id: [1, 2]).decoded_query).to eq({ "id" => "range=not.nxl.(1,2)", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.nxl(id: [1, 2]).decoded_query).to eq({ "id" => "range=nxl.(1,2)", "select" => "*" })
          end
        end
      end

      describe '#adj' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.adj(id: [1, 2]).decoded_query).to eq({ "id" => "range=not.adj.(1,2)", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.adj(id: [1, 2]).decoded_query).to eq({ "id" => "range=adj.(1,2)", "select" => "*" })
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

      describe '#order' do
        context 'when call not before' do
          it 'updates the query params' do
            expect(subject.not.order(name: :asc).decoded_query).to eq({ "order" => "name.desc", "select" => "*" })
          end
        end

        context 'when call it directly' do
          it 'updates the query params' do
            expect(subject.order(name: :asc).decoded_query).to eq({ "order" => "name.asc", "select" => "*" })
          end
        end
      end

      describe '#limit' do
        context 'when call it directly' do
          it 'it sets the limit instance variable' do
            subject.limit(10)
            expect(subject.decoded_query["limit"]).to eq(10)
          end
        end
      end

      describe '#offset' do
        context 'when call it directly' do
          it 'it sets the offset instance variable' do
            subject.offset(10)
            expect(subject.decoded_query["offset"]).to eq(10)
          end
        end
      end

      skip '#before_execute hooks' do; end

      describe 'scenarios' do
        context 'when combining limit + offset' do
          it 'sets both instance variables' do
            subject.limit(10).offset(10)
            expect(subject.decoded_query["limit"]).to eq(10)
            expect(subject.decoded_query["offset"]).to eq(10)
          end
        end

        context 'full query scenario' do
          it 'builds the query successfully' do
            subject.owners(:name, as: :owner)
              .workers(:name, as: :worker)
              .in(id: [112, 113])
              .order(id: :asc)
              .limit(10)
              .offset(5)

            expect(subject.decoded_query).to eq({
              "id" => "in.(112,113)",
              "limit" => 10,
              "offset" => 5,
              "order" => "id.asc",
              "select" => "*,owner:owners(name),worker:workers(name)"
            })
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
