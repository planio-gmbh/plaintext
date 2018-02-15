# frozen_string_literal: true

module Plaintext
  class PlaintextHandler < FileHandler
    CONTENT_TYPES = %w(text/csv text/plain)
    def initialize
      @content_types = CONTENT_TYPES
    end

    def text(file)
      Plaintext::CodesetUtil.to_utf8 IO.read(file), 'UTF-8'
    end
  end
end