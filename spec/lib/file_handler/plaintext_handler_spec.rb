# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::Resolver::PlaintextHandler do

  subject { described_class.new }

  it 'Should extract text from .txt files' do
    file = File.new('spec/fixtures/files/text.txt', 'r')
    expect(subject.text(file, 'text/plain')).to match /lorem/
  end

  it 'Should extract text from .csv files' do
    file = File.new('spec/fixtures/files/spreadsheet.csv', 'r')
    expect(subject.text(file, 'text/csv')).to match /lorem/
  end
end