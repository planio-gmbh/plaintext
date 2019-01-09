# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::RtfHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from .rtf files' do
      file = File.new('spec/fixtures/files/text.rtf', 'r')

      expect(subject.text(file)).to eq "lorem ipsum fulltext find me!\n"
      expect(Plaintext::Resolver.new(file, 'application/rtf').text).to match /lorem ipsum fulltext find me!/
    end

    it 'Should only extract text up to given size limit' do
      file = File.new('spec/fixtures/files/text.rtf', 'r')
      expect(subject.text(file, max_size: 5)).to eq 'lorem'

      r = Plaintext::Resolver.new(file, 'application/rtf')
      r.max_plaintext_bytes = 5
      expect(r.text).to eq "lorem"
    end

    it 'Should return a utf8 encoded string' do
      file = File.new('spec/fixtures/files/text.rtf', 'r')
      expect(subject.text(file).encoding.name).to eq 'UTF-8'
    end

  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end
