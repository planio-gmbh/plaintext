# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::DocHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from .doc files' do
      file = File.new('spec/fixtures/files/text.doc', 'r')

      expect(subject.text(file)).to match /lorem ipsum fulltext find me!/
      expect(TextExtractor::Resolver.new(file, 'application/msword').text).to match /lorem ipsum fulltext find me!/
      expect(TextExtractor::Resolver.new(file, 'application/vnd.ms-word').text).to match /lorem ipsum fulltext find me!/
    end

    it 'Should accept a pathname as input' do
      file = 'spec/fixtures/files/text.doc'
      expect(subject.text(file)).to match /lorem ipsum fulltext find me!/
    end

    it 'Should accept a path string as input' do
      file = Pathname('spec/fixtures/files/text.doc')
      expect(subject.text(file)).to match /lorem ipsum fulltext find me!/
    end

  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end
