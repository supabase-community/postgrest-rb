# frozen_string_literal: true

module Postgrest
  module Builders
    class FilterBuilder < BaseBuilder
      before_execute :set_limit, :set_offset, :update_http_instance

      SIMPLE_MATCHERS = %i[eq neq gt gte lt lte like is ilike fts plfts phfts wfts].freeze
      RANGE_MATCHERS = %i[sl sr nxr nxl adj].freeze

      def initialize(http)
        super
        @inverse_next = false
      end

      SIMPLE_MATCHERS.each do |method_name|
        define_method(method_name) do |values|
          transform_params(method_name: method_name, values: values)

          self
        end
      end

      RANGE_MATCHERS.each do |method_name|
        define_method(method_name) do |values|
          transform_params(method_name: method_name, values: values) do |key, value|
            [key, "range=#{method_key(method_name)}.(#{value.join(',')})"]
          end

          self
        end
      end

      def in(values = [])
        transform_params(method_name: __method__, values: values) do |key, value|
          [key, "#{method_key(__method__)}.(#{value.join(',')})"]
        end

        self
      end

      def order(values)
        transform_params(method_name: __method__, values: values) do |key, value|
          asc = value.to_sym != :desc
          asc = !asc if should_invert?

          [__method__, "#{key}.#{asc ? 'asc' : 'desc'}"]
        end

        self
      end

      def method_missing(method_name, *columns, as: nil)
        decoded_query['select'] += as ? ",#{as}:#{method_name}" : ",#{method_name}"
        decoded_query['select'] += columns.empty? ? '(*)' : "(#{columns.join(',')})"

        self
      end

      def query
        http.uri.query
      end

      def decoded_query
        @decoded_query ||= URI.decode_www_form(query).to_h
      end

      def limit(number = 0)
        decoded_query['limit'] = number
        self
      end

      def offset(number = 0)
        decoded_query['offset'] = number
        self
      end

      def not
        @inverse_next = !@inverse_next
        self
      end

      private

      def should_invert?
        @inverse_next
      end

      def transform_params(values:, method_name:)
        values.each do |k, v|
          key, value = yield(k, v) if block_given?
          key ||= k
          value ||= "#{method_key(method_name)}.#{v}"

          decoded_query[key.to_s] = value
        end

        @inverse_next = false
      end

      def method_key(name)
        should_invert? ? "not.#{name}" : name
      end

      # Before execute callback
      def update_http_instance
        http.update_query_params(decoded_query)
      end
    end
  end
end
