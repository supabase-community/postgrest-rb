# frozen_string_literal: true

require 'net/http'
require 'json'

module Postgrest
  class HTTP
    METHODS = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      put: Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }.freeze

    RESPONSES = {
      get: Responses::GetResponse,
      post: Responses::PostResponse,
      put: Responses::PutResponse,
      delete: Responses::DeleteResponse,
      options: Responses::GetResponse, # ?
    }

    attr_reader :request, :response, :query, :body, :headers, :http_method, :uri

    def initialize(uri:, query: {}, body: {}, headers: {}, http_method: :get)
      @uri = uri
      @body = body
      @headers = headers
      @http_method = http_method
      @response = nil
      @request = nil

      uri.query = URI.encode_www_form(query)
    end

    def update_query_params(new_value)
      @uri.query = URI.encode_www_form(new_value)
    end

    def call
      @response = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl?) do |http|
        @request = create_request
        http.request(request)
      end

      RESPONSES[http_method].new(request, response)
    end
    alias execute call

    private

    def create_request
      request = METHODS[http_method].new(uri)
      request.body = body.to_json
      request.content_type = 'application/json'
      set_request_headers(request)

      request
    end

    def use_ssl?
      uri.scheme == 'https'
    end

    def set_request_headers(request)
      headers.each {|key, value| request[key] = value }
      request['User-Agent'] = 'PostgREST Ruby Client'

      nil
    end
  end
end
