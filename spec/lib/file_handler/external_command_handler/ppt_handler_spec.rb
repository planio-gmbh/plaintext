# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::PptHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from .ppt files' do
      file = File.new('spec/fixtures/files/presentation.ppt', 'r')

      expect(subject.text(file, 'application/vnd.ms-powerpoint')).to match /lorem ipsum fulltext find me!/
      expect(subject.text(file, 'application/powerpoint')).to match /lorem ipsum fulltext find me!/
    end
  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end