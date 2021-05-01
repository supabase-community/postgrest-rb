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

        headers['Content-Type'] = 'application/json'

        nil
      end

      def get(uri:, query: {}, headers: {})
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          uri.query = URI.encode_www_form(query)
          req = Net::HTTP::Get.new(uri)
          set_request_headers(req, headers)
          http.request(req)
        end

        data = response_is_successful?(res) ? JSON.parse(res.body) : []

        Response.new({
                       error: !response_is_successful?(res),
                       data: data,
                       count: data.count,
                       status: res.code.to_i,
                       status_text: res.message,
                       body: query
                     })
      end

      def post(uri:, body: {}, headers: {})
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          req = Net::HTTP::Post.new(uri)
          req.body = body.to_json
          req.content_type = 'application/json'
          set_request_headers(req, headers)
          http.request(req)
        end

        Response.new({
                       error: !response_is_successful?(res),
                       data: res.body,
                       count: nil,
                       status: res.code.to_i,
                       status_text: res.message,
                       body: body
                     })
      end

      private

      def response_is_successful?(response)
        response.class.ancestors.include?(Net::HTTPSuccess)
      end
    end
  end
end
