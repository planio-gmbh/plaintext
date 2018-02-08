# frozen_string_literal: true

module TextExtractor
  class ImageHandler < ExternalCommandHandler
    CONTENT_TYPES = [
        'image/jpeg',
        'image/png',
        'image/tiff'
    ]
    DEFAULT = [
        '/usr/bin/tesseract', '__FILE__', 'stdout'
    ].freeze
    def initialize
      @content_types = CONTENT_TYPES
      @command = TextExtractor::FileHandler::TEXT_EXTRACTORS['tesseract'] || DEFAULT
    end
  end
end
