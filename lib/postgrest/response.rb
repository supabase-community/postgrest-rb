module Postgrest
  class Response
    attr_reader :error, :data, :count, :status, :status_text, :body

    def initialize(data:, status:, status_text:, body:, error: nil, count: 0)
      @error = error
      @data = data
      @count = count
      @status = status
      @status_text = status_text
      @body = body
    end
  end
end
