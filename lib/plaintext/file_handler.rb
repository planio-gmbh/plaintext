# frozen_string_literal: true

module Plaintext
  class FileHandler
    def accept?(content_type)
      if @content_type
        content_type == @content_type
      elsif @content_types
        @content_types.include? content_type
      else
        false
      end
    end
  end
end