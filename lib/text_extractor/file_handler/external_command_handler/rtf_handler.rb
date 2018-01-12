# frozen_string_literal: true

module TextExtractor
  class RtfHandler < ExternalCommandHandler
    DEFAULT = [
        '/usr/bin/unrtf', '--text', '__FILE__'
    ].freeze
    def initialize
      @content_type = 'application/rtf'
      @command = TextExtractor::FileHandler::TEXT_EXTRACTORS['unrtf'] || DEFAULT
    end
  end
end
