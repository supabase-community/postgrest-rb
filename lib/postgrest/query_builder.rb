# frozen_string_literal: true

module Postgrest
  class QueryBuilder
    attr_accessor :uri, :headers, :schema

    def initialize(url:, headers:, schema:)
      @uri = URI(url)
      @headers = headers
      @schema = schema
    end

    def select(columns = '*')
      Postgrest::HTTP.get(uri: uri, query: { select: columns }, headers: headers)
    end

    # @client.from('todos').insert([
    #   { title: 'The Shire', completed: false },
    #   { title: 'The Shire', completed: false },
    # ])

    # @client.from('todos').insert({ name: 'The Shire', country_id: 554 })

    def insert(values)
      Postgrest::HTTP.post(uri: uri, body: values, headers: headers)
    end
  end
end
