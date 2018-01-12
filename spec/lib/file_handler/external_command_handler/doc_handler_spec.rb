# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::DocHandler do

  subject { described_class.new }

  if TextExtractor::DocHandler.available?
    it 'Should extract text from .doc files' do
      file = File.new('spec/fixtures/files/text.doc', 'r')

      expect(subject.text(file, 'application/vnd.ms-word')).to match /lorem ipsum fulltext find me!/
      expect(subject.text(file, 'application/msword')).to match /lorem ipsum fulltext find me!/
    end
  else
    warn "DocHanlder could not be tested as external program is not available."
  end
end