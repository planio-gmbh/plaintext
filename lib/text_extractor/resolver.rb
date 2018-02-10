# frozen_string_literal: true

module TextExtractor
  class Resolver
    MAX_FULLTEXT_LENGTH = 4_194_304 # 4 megabytes

    class << self
      attr_accessor :cached_file_handlers

      HANDLERS = [
          TextExtractor::PdfHandler,
          TextExtractor::OpendocumentHandler,
          TextExtractor::DocxHandler, TextExtractor::XlsxHandler, TextExtractor::PptxHandler,
          TextExtractor::DocHandler, TextExtractor::XlsHandler, TextExtractor::PptHandler,
          TextExtractor::ImageHandler,
          TextExtractor::RtfHandler,
          TextExtractor::PlaintextHandler
      ].freeze

      def file_handlers
        return self.cached_file_handlers if self.cached_file_handlers.present?
        self.cached_file_handlers = HANDLERS.map(&:new)
      end
    end

    def initialize(file, content_type = nil)
      @file = file
      @content_type = content_type
    end

    # Returns the extracted fulltext or nil if no matching handler was found
    # for the file type.
    def text
      if handler = find_handler and text = handler.text(@file)
        text.gsub! /\s+/m, ' '
        text.strip!
        text.mb_chars.compose.limit(MAX_FULLTEXT_LENGTH).to_s
      end
    end

    private

    def find_handler
      self.class.file_handlers.detect { |h| h.accept? @content_type }
    end

  end
end
