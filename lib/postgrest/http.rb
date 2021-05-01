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

        request
      end

      def get(uri:, query: {}, headers: {})
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          uri.query = URI.encode_www_form(query)
          req = Net::HTTP::Get.new(uri)
          set_request_headers(req, headers)
          http.request(req)
        end

        raise RequestError.new("#{res.code} #{res.message}") unless res.code.eql?('200')

        JSON.parse(res.body)
      end

      def post(uri:, body: {}, headers: {})
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          req = Net::HTTP::Post.new(uri)
          req.set_form_data(body)
          set_request_headers(req, headers)
          http.request(req)
        end

        raise RequestError.new("#{res.code} #{res.message}") unless res.code.eql?('201')

        body
      end
    end
  end
end