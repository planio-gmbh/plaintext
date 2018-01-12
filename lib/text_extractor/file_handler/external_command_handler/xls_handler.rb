# frozen_string_literal: true

module TextExtractor
  class XlsHandler < ExternalCommandHandler
    CONTENT_TYPES = [
      'application/vnd.ms-excel',
      'application/excel'
    ]
    DEFAULT = [
        '/usr/bin/xls2csv', '-dutf-8', '__FILE__'
    ]
    def initialize
      @content_types = CONTENT_TYPES
      @command = TextExtractor::FileHandler::TEXT_EXTRACTORS['xls2csv'] || DEFAULT
    end
    def text(*_)
      if str = super
        str.delete('"').gsub /,+/, ' '
      end
    end
  end
end