# frozen_string_literal: true

require 'text_extractor/version'
require 'text_extractor/configuration'

require 'text_extractor/file_handler'
require 'text_extractor/file_handler/external_command_handler'
require 'text_extractor/file_handler/external_command_handler/doc_handler'
require 'text_extractor/file_handler/external_command_handler/pdf_handler'
require 'text_extractor/file_handler/external_command_handler/ppt_handler'
require 'text_extractor/file_handler/external_command_handler/rtf_handler'
require 'text_extractor/file_handler/external_command_handler/xls_handler'

require 'text_extractor/file_handler/zipped_xml_handler'
require 'text_extractor/file_handler/zipped_xml_handler/office_document_handler'
require 'text_extractor/file_handler/zipped_xml_handler/office_document_handler/docx_handler'
require 'text_extractor/file_handler/zipped_xml_handler/office_document_handler/pptx_handler'
require 'text_extractor/file_handler/zipped_xml_handler/office_document_handler/xlsx_handler'
require 'text_extractor/file_handler/zipped_xml_handler/opendocument_handler'

require 'text_extractor/file_handler/plaintext_handler'

require 'text_extractor/resolver'

# require 'text_extractor/file_handler/plaintext_handler'
# require 'text_extractor/resolver'

module TextExtractor
  module CodesetUtil
    def self.to_utf8(str, encoding)
      return str if str.nil?
      str.force_encoding('ASCII-8BIT')
      if str.empty?
        str.force_encoding('UTF-8')
        return str
      end
      enc = (encoding.nil? || encoding.size == 0) ? 'UTF-8' : encoding
      if enc.upcase != 'UTF-8'
        str.force_encoding(enc)
        str = str.encode('UTF-8', invalid: :replace,
                         undef: :replace, replace: '?')
      else
        str.force_encoding('UTF-8')
        if !str.valid_encoding?
          str = str.encode('US-ASCII', invalid: :replace,
                           undef: :replace, replace: '?').encode('UTF-8')
        end
      end
      str
    end
  end

end

