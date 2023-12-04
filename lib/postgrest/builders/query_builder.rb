# frozen_string_literal: true

module Postgrest
  module Builders
    class QueryBuilder
      attr_reader :uri, :headers, :schema

      def initialize(url:, headers:, schema:)
        @uri = URI(url)
        @headers = headers
        @schema = schema
      end

      def select(*columns, extra_headers: {})
        columns.compact!
        columns = ['*'] if columns.length.zero?
        extra_headers[:'Accept-Profile'] ||= schema
        request = HTTP.new(uri: uri, query: { select: columns.join(',') }, headers: headers.merge(extra_headers))

        FilterBuilder.new(request)
      end

      def insert(values)
        upsert(values, extra_headers: { Prefer: 'return=representation' })
      end

      def upsert(values, extra_headers: {})
        extra_headers[:Prefer] ||= 'return=representation,resolution=merge-duplicates'
        extra_headers[:'Content-Profile'] ||= schema
        request = HTTP.new(uri: uri, body: values, http_method: :post, headers: headers.merge(extra_headers))

        BaseBuilder.new(request)
      end

      def update(values, extra_headers: {})
        extra_headers[:Prefer] ||= 'return=representation'
        extra_headers[:'Content-Profile'] ||= schema
        request = HTTP.new(uri: uri, body: values, http_method: :patch, headers: headers.merge(extra_headers))

        FilterBuilder.new(request)
      end

      def delete(extra_headers: {})
        extra_headers[:Prefer] ||= 'return=representation'
        extra_headers[:'Content-Profile'] ||= schema
        request = HTTP.new(uri: uri, http_method: :delete, headers: headers.merge(extra_headers))

        FilterBuilder.new(request)
      end
    end
  end
end
