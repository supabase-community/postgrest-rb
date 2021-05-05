# frozen_string_literal: true

module Postgrest
  module Builders
    class BaseBuilder
      def self._before_execute
        @before_execute ||= {}
        @before_execute[self] ||= []
        @before_execute[self]
      end

      def self.before_execute(*values)
        @before_execute ||= {}
        @before_execute[self] = values
      end

      attr_reader :http

      def initialize(http)
        @http = http
        # {:eq=>[[:id, "eq.1"]], :in=>[[:id, "in.(1,2)"]], :owners=>[[:name]]}
        # Will be present in the next version
        @options = {}
      end

      def call
        self.class._before_execute.each { |method_name| send(method_name) }

        http.call
      end
      alias execute call
    end
  end
end
