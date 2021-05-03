# frozen_string_literal: true

require 'postgrest/version'
require 'postgrest/http'
require 'postgrest/client'

# Builders
require 'postgrest/builders/base_builder'
require 'postgrest/builders/query_builder'
require 'postgrest/builders/filter_builder'

# Responses

require 'postgrest/response'
require 'postgrest/responses/get_response'
require 'postgrest/responses/post_response'
require 'postgrest/responses/put_response'
require 'postgrest/responses/delete_response'


module Postgrest
  class MissingTableError < StandardError; end

  class RequestError < StandardError; end
end
