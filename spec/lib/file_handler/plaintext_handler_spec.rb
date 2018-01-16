# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::PlaintextHandler do

  subject { described_class.new }

  it 'Should extract text from .txt files' do
    file = File.new('spec/fixtures/files/text.txt', 'r')
    expect(subject.text(file)).to match /lorem/
    expect(TextExtractor::Resolver.new(file, 'text/plain').text).to match /lorem ipsum/
  end

  it 'Should extract text from .csv files' do
    file = File.new('spec/fixtures/files/spreadsheet.csv', 'r')
    expect(subject.text(file)).to match /lorem/
    expect(TextExtractor::Resolver.new(file, 'text/csv').text).to match /lorem/
  end
end