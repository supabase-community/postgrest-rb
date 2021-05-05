# frozen_string_literal: true

module Postgrest
  module Builders
    class FilterBuilder < BaseBuilder
      before_execute :set_limit, :set_offset

      def initialize(http)
        super
        @inverse_next = false
      end

      %i[
        eq neq gt gte lt lte like is
        ilike fts plfts phfts wfts
      ].each do |method_name|
        define_method(method_name) do |values|
          update_query(method_name: method_name, values: values)
          self
        end
      end

      def in(values = [])
        update_query(method_name: __method__, values: values) do |key, value|
          [key, "#{method_key(__method__)}.(#{value.join(',')})"]
        end

        self
      end

      def order(values)
        update_query(method_name: __method__, values: values) do |key, value|
          asc = value.to_sym != :desc
          asc = !asc if @inverse_next
          reset_inverse_next

          [__method__, "#{key}.#{asc ? 'asc' : 'desc'}"]
        end

        self
      end

      def method_missing(method_name, *columns)
        @options[method_name] ||= []
        @options[method_name] << columns
        self
      end

      def query
        http.uri.query
      end

      def limit(number = 0)
        @limit = number
        self
      end

      def offset(number = 0)
        @offset = number
        self
      end

      def not
        @inverse_next = !@inverse_next
        self
      end

      private

      def update_query(values:, method_name:)
        query = URI.decode_www_form(http.uri.query)

        values.each do |key, value|
          formatted_value = yield(key, value) if block_given?
          formatted_value ||= [key, "#{method_key(method_name)}.#{value}"]

          query << formatted_value
          @options[method_name] ||= []
          @options[method_name] << formatted_value
        end

        reset_inverse_next
        http.update_query_params(query)
      end

      def reset_inverse_next
        @inverse_next = false
      end

      def method_key(name)
        @inverse_next ? "not.#{name}" : name
      end

      def set_offset
        return unless @offset

        update_query(values: [@offset], method_name: :offset) do
          [:offset, @offset]
        end
      end

      def set_limit
        return unless @limit

        update_query(values: [@limit], method_name: :limit) do
          [:limit, @limit]
        end
      end
    end
  end
end
