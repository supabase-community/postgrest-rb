# frozen_string_literal: true

module Postgrest
  module Builders
    class BaseBuilder
      def self.before_execute_hooks
        @before_execute ||= []
        @before_execute
      end

      def self.before_execute(*values)
        @before_execute = values
      end

      attr_reader :http

      def initialize(http)
        @http = http
      end

      def call
        self.class.before_execute_hooks.each { |method_name| send(method_name) }

        http.call
      end
      alias execute call
    end
  end
end
