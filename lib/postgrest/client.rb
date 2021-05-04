# frozen_string_literal: true

module Postgrest
  class Client
    DEFAULT_SCHEMA = 'public'

    attr_reader :url, :headers, :schema

    def initialize(url:, headers: {}, schema: DEFAULT_SCHEMA)
      @url = URI(url)
      @headers = headers
      @schema = schema
    end

    def from(table)
      raise MissingTableError if table.nil? || table.empty?

      Builders::QueryBuilder.new(url: "#{url}/#{table}", headers: headers, schema: schema)
    end
  end
end
