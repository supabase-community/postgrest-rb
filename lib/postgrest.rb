# frozen_string_literal: true

require 'postgrest/version'

# Builders
require 'postgrest/builders/base_builder'
require 'postgrest/builders/query_builder'
require 'postgrest/builders/filter_builder'

# Responses
require 'postgrest/responses/base_response'
require 'postgrest/responses/get_response'
require 'postgrest/responses/post_response'
require 'postgrest/responses/patch_response'
require 'postgrest/responses/delete_response'

require 'postgrest/http'
require 'postgrest/client'

module Postgrest
  class MissingTableError < StandardError; end

  class InvalidHTTPMethod < ArgumentError; end

  class RequestError < StandardError; end
end
