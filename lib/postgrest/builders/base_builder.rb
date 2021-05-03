# frozen_string_literal: true

module Postgrest
  module Builders
    class BaseBuilder
      attr_reader :http

      def initialize(http)
        @http = http
      end

      def call
        http.call
      end

      alias execute call
    end
  end
end
