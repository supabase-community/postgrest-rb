# frozen_string_literal: true

require 'net/http'
require 'json'

module Postgrest
  class HTTP
    class << self
      def set_request_headers(request, headers = {})
        headers.each do |key, value|
          request[key] = value
        end

        request['Content-Type'] = 'application/json'

        # count?: null | 'exact' | 'planned' | 'estimated'
        # returning?: 'minimal' | 'representation'

        prefer = ['return=representation', 'resolution=merge-duplicates', 'count=exact']
        request['Prefer'] = prefer.join(',')

        nil
      end

      def get(uri:, query: {}, headers: {})
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          uri.query = URI.encode_www_form(query)
          req = Net::HTTP::Get.new(uri)
          set_request_headers(req, headers)
          http.request(req)
        end

        get_response(response: response, body: query)
      end

      def post(uri:, body: {}, headers: {})
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          req = Net::HTTP::Post.new(uri)
          req.body = body.to_json
          req.content_type = 'application/json'
          set_request_headers(req, headers)
          http.request(req)
        end

        post_response(response: response, body: body)
      end

      private

      def response_is_successful?(response)
        response.class.ancestors.include?(Net::HTTPSuccess)
      end

      def parse_post_response(response)
        return unless response_is_successful?(response)

        body = response.body.empty? ? '{}' : response.body

        JSON.parse(body)
      end

      def get_response(response:, body:)
        data = response_is_successful?(response) ? JSON.parse(response.body) : []

        Response.new({
                       error: !response_is_successful?(response),
                       data: data,
                       count: data.count,
                       status: response.code.to_i,
                       status_text: response.message,
                       body: body
                     })
      end

      def post_response(response:, body:)
        Response.new({
                       error: !response_is_successful?(response),
                       data: parse_post_response(response),
                       count: nil,
                       status: response.code.to_i,
                       status_text: response.message,
                       body: body
                     })
      end
    end
  end
end
