# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::PptHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from .ppt files' do
      file = File.new('spec/fixtures/files/presentation.ppt', 'r')

      expect(subject.text(file)).to match /Die Java Virtual Machine/
      expect(TextExtractor::Resolver.new(file, 'application/powerpoint').text).to match /Die Java Virtual Machine/
      expect(TextExtractor::Resolver.new(file, 'application/vnd.ms-powerpoint').text).to match /Die Java Virtual Machine/
    end

    it 'Should accept a pathname as input' do
      file = 'spec/fixtures/files/presentation.ppt'
      expect(subject.text(file)).to match /Die Java Virtual Machine/
    end

    it 'Should accept a path string as input' do
      file = Pathname('spec/fixtures/files/presentation.ppt')
      expect(subject.text(file)).to match /Die Java Virtual Machine/
    end

  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end
