# frozen_string_literal: true

require 'postgrest/version'
require 'postgrest/http'
require 'postgrest/client'
require 'postgrest/query_builder'
require 'postgrest/response'

module Postgrest
  class MissingTableError < StandardError; end

  class RequestError < StandardError; end
end
