# frozen_string_literal: true

module Postgrest
  module Responses
    class BaseResponse
      attr_reader :request, :response

      def initialize(request, response)
        @request = request
        @response = response
        @data = data
      end

      def inspect
        "\#<#{self.class} #{request.method} #{response.message} data=#{@data}>"
      end

      def error
        !response.is_a?(Net::HTTPSuccess)
      end

      def count
        data.count
      end

      def status
        response.code.to_i
      end

      def status_text
        response.message
      end

      def data
        error ? [] : safe_json_parse(response.body)
      end
      alias as_json data

      def params
        {
          query: request.uri.query,
          body: safe_json_parse(request.body)
        }
      end

      private

      def safe_json_parse(json)
        JSON.parse(json)
      rescue TypeError, JSON::ParserError
        {}
      end
    end
  end
end
