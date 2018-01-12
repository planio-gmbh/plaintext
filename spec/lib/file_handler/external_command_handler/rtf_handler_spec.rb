# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::RtfHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from .rtf files' do
      file = File.new('spec/fixtures/files/text.rtf', 'r')

      expect(subject.text(file, 'application/rtf')).to match /lorem ipsum fulltext find me!/
    end
  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end