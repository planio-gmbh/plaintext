# frozen_string_literal: true

module Plaintext
  class RtfHandler < ExternalCommandHandler
    DEFAULT = [
        '/usr/bin/unrtf', '--text', '__FILE__'
    ].freeze
    def initialize
      @content_type = 'application/rtf'
      @command = Plaintext::Configuration['unrtf'] || DEFAULT
    end
  end
end
