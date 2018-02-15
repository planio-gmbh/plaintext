# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::XlsHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from .xls files' do
      file = File.new('spec/fixtures/files/spreadsheet.xls', 'r')

      expect(subject.text(file)).to match /ipsum fulltext find me!/
      expect(subject.text(file)).to match /ipsum fulltext find me!/

      expect(Plaintext::Resolver.new(file, 'application/vnd.ms-excel').text).to match /ipsum fulltext find me!/
      expect(Plaintext::Resolver.new(file, 'application/excel').text).to match /ipsum fulltext find me!/
    end
  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end