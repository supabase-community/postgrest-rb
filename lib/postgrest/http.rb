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

    attr_reader :request, :response, :query, :body, :headers, :method, :uri

    def initialize(uri:, query: {}, body: {}, headers: {}, method: :get)
      @uri = uri
      @query = query
      @body = body
      @headers = headers
      @method = method
      @response = nil
      @request = nil

      prepare
    end

    def call
      @response = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: use_ssl?) do |http|
        http.request(request)
      end

      switch_response
    end

    alias execute call

    private

    def prepare
      uri.query = URI.encode_www_form(query)
      @request = METHODS[method].new(uri)
      @request.body = body.to_json
      @request.content_type = 'application/json'
      set_request_headers

      @request
    end

    def switch_response
      case request.method
      when 'GET'
        get_response # > Responses::GetResponse.new
      when 'POST'
        post_response # > Responses::PostResponse.new
      when 'DELETE'
        get_response # > Responses::DeleteResponse.new
      when 'PUT'
        post_response # > Responses::PutResponse.new
      end
    end

    def use_ssl?
      return unless request

      request.uri.scheme == 'https'
    end

    def set_request_headers
      headers.each {|key, value| request[key] = value }
      request['User-Agent'] = 'PostgREST Ruby Client'

      nil
    end

    def response_is_successful?
      response.class.ancestors.include?(Net::HTTPSuccess)
    end

    def parse_post_response
      return unless response_is_successful?

      JSON.parse(response.body.empty? ? '{}' : response.body)
    end

    def get_response
      data = response_is_successful? ? JSON.parse(response.body) : []

      response_params = {
        error: !response_is_successful?,
        data: data,
        count: data.count,
        status: response.code.to_i,
        status_text: response.message,
        body: request.uri.query
      }

      Response.new(response_params)
    end

    def post_response
      data = parse_post_response

      response_params = {
        error: !response_is_successful?,
        data: data,
        count: data.count,
        status: response.code.to_i,
        status_text: response.message,
        body: JSON.parse(response.body)
      }

      Response.new(response_params)
    end
  end
end
