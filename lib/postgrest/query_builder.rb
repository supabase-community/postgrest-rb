# frozen_string_literal: true

module Postgrest
  class QueryBuilder
    attr_accessor :uri, :headers, :schema

    def initialize(url:, headers:, schema:)
      @uri = URI(url)
      @headers = headers
      @schema = schema
    end

    def select(columns = '*', options = {})
      # @client.from('todos').select('*', { id: 'gt.35' })

      Postgrest::HTTP.get(uri: uri, query: { select: columns }.merge(options), headers: headers)
    end

    def insert(values)
      Postgrest::HTTP.post(uri: uri, body: values, headers: headers)
    end

    def update(values); end

    def match(values); end
  end
end
