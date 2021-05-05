# frozen_string_literal: true

require 'net/http'
require 'json'

module Postgrest
  class HTTP
    METHODS = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      patch: Net::HTTP::Patch,
      put: Net::HTTP::Patch,
      delete: Net::HTTP::Delete
    }.freeze

    RESPONSES = {
      get: Responses::GetResponse,
      post: Responses::PostResponse,
      put: Responses::PatchResponse,
      patch: Responses::PatchResponse,
      delete: Responses::DeleteResponse,
      options: Responses::GetResponse # ?
    }.freeze

    USER_AGENT = 'PostgREST Ruby Client'

    attr_reader :request, :response, :query, :body, :headers, :http_method, :uri

    def initialize(uri:, query: {}, body: {}, headers: {}, http_method: :get)
      @uri = uri
      @body = body
      @headers = headers
      @http_method = http_method.to_sym
      @response = nil
      @request = nil
      uri.query = decode_query_params(query)
    end

    def update_query_params(new_value = {})
      @uri.query = decode_query_params(new_value)
    rescue NoMethodError
      @uri.query
    end

    def call
      raise InvalidHTTPMethod unless valid_http_method?

      @response = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl?) do |http|
        @request = create_request
        http.request(request)
      end

      RESPONSES[http_method].new(request, response)
    end
    alias execute call

    private

    def decode_query_params(query_params)
      URI.decode(URI.encode_www_form(query_params))
    end

    def create_request
      request = METHODS[http_method].new(uri)
      request.body = body.to_json
      request.content_type = 'application/json'
      add_headers(request)

      request
    end

    def use_ssl?
      uri.scheme == 'https'
    end

    def add_headers(request)
      headers.each { |key, value| request[key] = value }
      request['User-Agent'] = USER_AGENT

      nil
    end

    def valid_http_method?
      METHODS.keys.include?(http_method)
    end
  end
end
