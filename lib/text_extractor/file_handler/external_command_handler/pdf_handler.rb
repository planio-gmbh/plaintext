# frozen_string_literal: true

module TextExtractor
  class PdfHandler < ExternalCommandHandler
    DEFAULT = [
        '/usr/bin/pdftotext', '-enc', 'UTF-8', '__FILE__', '-'
    ].freeze
    def initialize
      @content_type = 'application/pdf'
      @command = TextExtractor::FileHandler::TEXT_EXTRACTORS['pdftotext'] || DEFAULT
    end
  end
end