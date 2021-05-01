# frozen_string_literal: true

module Postgrest
  class Response
    attr_reader :error, :data, :count, :status, :status_text, :body

    def initialize(params = {})
      @error = params[:error]
      @data = params[:data]
      @count = params[:count]
      @status = params[:status]
      @status_text = params[:status_text]
      @body = params[:body]
    end
  end
end
