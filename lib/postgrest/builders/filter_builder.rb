# frozen_string_literal: true

module Postgrest
  module Builders
    class FilterBuilder < BaseBuilder
      attr_accessor :inverse_next

      def initialize(http)
        super
        @inverse_next = false
      end

      %i[
        eq neq gt gte lt lte like
        ilike fts plfts phfts wfts
      ].each do |method_name|
        define_method(method_name) do |values|
          query = begin
            URI.decode_www_form(http.uri.query)
          rescue StandardError
            []
          end
          word = inverse_next ? "n#{method_name}" : method_name

          @inverse_next = false
          values.each { |key, value| query << [key, "#{word}.#{value}"] }

          http.update_query_params(query)

          self
        end
      end

      def not
        @inverse_next = true
        self
      end
    end
  end
end
