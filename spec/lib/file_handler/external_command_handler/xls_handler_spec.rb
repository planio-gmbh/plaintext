# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::XlsHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from .xls files' do
      file = File.new('spec/fixtures/files/spreadsheet.xls', 'r')

      expect(subject.text(file, 'application/vnd.ms-excel')).to match /lorem ipsum fulltext find me!/
      expect(subject.text(file, 'application/excel')).to match /lorem ipsum fulltext find me!/
    end
  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end