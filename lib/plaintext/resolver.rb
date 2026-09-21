# frozen_string_literal: true

module Plaintext
  class Resolver

    # maximum length of returned plain text in bytes. Default: 4MB
    attr_accessor :max_plaintext_bytes

    # keep the whitespace emitted by the handler instead of collapsing it
    # into single spaces. Default: false
    attr_accessor :preserve_whitespace

    class << self
      attr_accessor :cached_file_handlers

      HANDLERS = [
          Plaintext::PdfHandler,
          Plaintext::OpendocumentHandler,
          Plaintext::DocxHandler, Plaintext::XlsxHandler, Plaintext::PptxHandler,
          Plaintext::DocHandler, Plaintext::XlsHandler, Plaintext::PptHandler,
          Plaintext::ImageHandler,
          Plaintext::RtfHandler,
          Plaintext::PlaintextHandler
      ].freeze

      def file_handlers
        return self.cached_file_handlers if self.cached_file_handlers.present?
        self.cached_file_handlers = HANDLERS.map(&:new)
      end
    end

    def initialize(file, content_type = nil)
      @file = file
      @content_type = content_type
      @max_plaintext_bytes = 4_194_304 # 4 megabytes
      @preserve_whitespace = false
    end


    # Returns the extracted fulltext or nil if no matching handler was found
    # for the file type.
    def text
      if handler = find_handler and
          text = handler.text(@file, max_size: max_plaintext_bytes)

        unless preserve_whitespace
          text = +text
          text.gsub!(/\s+/m, ' ')
          text.strip!
        end
        text.unicode_normalize(:nfc).truncate_bytes(max_plaintext_bytes, omission: nil)
      end
    end

    private

    def find_handler
      self.class.file_handlers.detect { |h| h.accept? @content_type }
    end

  end
end
