# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::PptHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from .ppt files' do
      file = File.new('spec/fixtures/files/presentation.ppt', 'r')

      expect(subject.text(file)).to match /The title/
      expect(TextExtractor::Resolver.new(file, 'application/powerpoint').text).to match /The Title find me Slide two/
      expect(TextExtractor::Resolver.new(file, 'application/vnd.ms-powerpoint').text).to match /The Title find me Slide two/
    end
  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end