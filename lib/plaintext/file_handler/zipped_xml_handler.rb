# frozen_string_literal: true

module Plaintext
  # Handler base class for XML based (MS / Open / Libre) office documents.
  class ZippedXmlHandler < FileHandler
    require 'zip'
    require 'nokogiri'

    class SaxDocument < Nokogiri::XML::SAX::Document
      attr_reader :text

      def initialize(text_element, text_namespace)
        @element = text_element
        @namespace_uri = text_namespace
        @text = ''.dup
        @is_text = false
      end

      # Handle each element, expecting the name and any attributes
      def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
        if name == @element and uri == @namespace_uri
          @is_text = true
        end
      end

      # Any characters between the start and end element expected as a string
      def characters(string)
        @text << string if @is_text
      end

      # Given the name of an element once its closing tag is reached
      def end_element_namespace(name, prefix = nil, uri = nil)
        if name == @element and uri == @namespace_uri
          @text << ' '
          @is_text = false
        end
      end
    end

    def text(file)
      Zip::File.open(file) do |zip_file|
        zip_file.each do |entry|
          if entry.name == @file_name
            return xml_to_text entry.get_input_stream
          end
        end
      end
    end

    private

    def xml_to_text(io)
      sax_doc = SaxDocument.new @element, @namespace_uri
      Nokogiri::XML::SAX::Parser.new(sax_doc).parse(io)
      sax_doc.text
    end
  end
end