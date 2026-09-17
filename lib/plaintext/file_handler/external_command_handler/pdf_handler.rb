# frozen_string_literal: true

require 'open3'

module Plaintext
  class PdfHandler < ExternalCommandHandler
    DEFAULT = [
        '/usr/bin/pdftotext', '-enc', 'UTF-8', '__FILE__', '-'
    ].freeze

    URLS_INCOMPATIBLE_FLAGS = ['-bbox', '-bbox-layout', '-tsv', '-htmlmeta'].freeze

    def initialize
      @content_type = 'application/pdf'
      @command = (Plaintext::Configuration['pdftotext'] || DEFAULT).dup
      @command.insert(@command.index(FILE_PLACEHOLDER), '-urls') if urls_applicable? && urls_wanted?
    end

    def self.supports_urls?(binary)
      @supports_urls ||= {}
      @supports_urls.fetch(binary) do
        @supports_urls[binary] = begin
          File.executable?(binary) && Open3.capture2e(binary, '-h')[0].include?('-urls')
        rescue SystemCallError
          false
        end
      end
    end

    private

    def urls_applicable?
      @command.is_a?(Array) &&
        !@command.include?('-urls') &&
        (@command & URLS_INCOMPATIBLE_FLAGS).empty? &&
        @command.include?(FILE_PLACEHOLDER)
    end

    def urls_wanted?
      case Plaintext::Configuration['pdftotext_urls']
      when true then true
      when false then false
      else self.class.supports_urls?(@command.first)
      end
    end
  end
end
