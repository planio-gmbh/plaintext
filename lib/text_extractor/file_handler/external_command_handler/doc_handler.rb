# frozen_string_literal: true

module TextExtractor
  class DocHandler < ExternalCommandHandler
    CONTENT_TYPES = [
        'application/vnd.ms-word',
        'application/msword'
    ]
    DEFAULT = [
        '/usr/bin/catdoc', '-dutf-8', '__FILE__'
    ]
    def initialize
      @content_types = CONTENT_TYPES
      @command = TextExtractor::FileHandler::TEXT_EXTRACTORS['catdoc'] || DEFAULT
    end
  end
end