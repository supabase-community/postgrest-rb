# frozen_string_literal: true

module Postgrest
  module Builders
    class BaseBuilder
      attr_accessor :request

      def initialize(request)
        @request = request
      end

      def call
        request.call
      end

      alias execute call
    end
  end
end
