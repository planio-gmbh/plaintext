# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::PdfHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from .pdf files' do
      file = File.new('spec/fixtures/files/text.pdf', 'r')

      expect(subject.text(file)).to match /lorem ipsum fulltext find me!/
      expect(Plaintext::Resolver.new(file, 'application/pdf').text).to match /lorem ipsum fulltext find me!/
    end

    it 'should extract umlauts correctly into UTF-8' do
      file = File.new('spec/fixtures/files/text-with-umlaut.pdf', 'r')

      expect(subject.text(file)).to match /In der Küche hat es eine Kaffeemaschine/
      expect(Plaintext::Resolver.new(file, 'application/pdf').text).to match /In der Küche hat es eine Kaffeemaschine/
    end
  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end
