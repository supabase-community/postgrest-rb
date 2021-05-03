# frozen_string_literal: true

module Postgrest
  module Builders
    class FilterBuilder < BaseBuilder
      attr_accessor :inverse_next

      def initialize(request)
        super
        @inverse_next = false
      end

      %i[
        eq neq gt gte lt lte like
        ilike fts plfts phfts wfts
      ].each do |method_name|
        define_method(method_name) do |values|
          query = URI.decode_www_form(request.uri.query)
          word = inverse_next ? "n#{method_name}" : method_name
          self.inverse_next = false
          values.each { |key, value| query << [key, "#{word}.#{value}"] }
          request.uri.query = URI.encode_www_form(query)

          self
        end
      end

      def not
        self.inverse_next = true
        self
      end
    end
  end
end
