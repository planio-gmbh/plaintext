# frozen_string_literal: true

require 'active_support/core_ext/string'

require 'text_extractor/version'
require 'text_extractor/configuration'

require 'text_extractor/codeset_util'

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
