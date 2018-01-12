# frozen_string_literal: true

module TextExtractor
  # Base class for extractors for MS Office formats
  class OfficeDocumentHandler < ZippedXmlHandler
    def initialize
      super
      @element = 't'
    end
  end
end