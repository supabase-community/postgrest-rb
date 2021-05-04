# frozen_string_literal: true

module Postgrest
  module Builders
    class FilterBuilder < BaseBuilder
      def initialize(http)
        super
        @inverse_next = false
      end

      %i[
        eq neq gt gte lt lte like
        ilike fts plfts phfts wfts
      ].each do |method_name|
        define_method(method_name) do |values|
          query = URI.decode_www_form(http.uri.query)
          values.each { |key, value| query << [key, "#{method_key(method_name)}.#{value}"] }
          reset_inverse_next
          http.update_query_params(query)

          self
        end
      end

      def query
        http.uri.query
      end

      def not
        @inverse_next = !@inverse_next
        self
      end

      private

      def reset_inverse_next
        @inverse_next = false
      end

      def method_key(name)
        @inverse_next ? "not.#{name}" : name
      end
    end
  end
end
