# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::PlaintextHandler do

  subject { described_class.new }

  it 'Should extract text from .txt files' do
    file = File.new('spec/fixtures/files/text.txt', 'r')
    expect(subject.text(file)).to match /lorem/
    expect(Plaintext::Resolver.new(file, 'text/plain').text).to match /lorem ipsum/
  end

  it 'Should extract text from .csv files' do
    file = File.new('spec/fixtures/files/spreadsheet.csv', 'r')
    expect(subject.text(file)).to match /lorem/
    expect(Plaintext::Resolver.new(file, 'text/csv').text).to match /lorem/
  end

  it 'Should accept a path string as input' do
    file = 'spec/fixtures/files/text.txt'
    expect(subject.text(file)).to match /lorem/
    expect(Plaintext::Resolver.new(file, 'text/plain').text).to match /lorem ipsum/
  end

  it 'Should accept a pathname as input' do
    file = Pathname('spec/fixtures/files/text.txt')
    expect(subject.text(file)).to match /lorem/
    expect(Plaintext::Resolver.new(file, 'text/plain').text).to match /lorem ipsum/
  end

  it 'Should only extract text up to given size limit' do
    file = File.new('spec/fixtures/files/text.txt', 'r')
    expect(subject.text(file, max_size: 2)).to eq 'lo'

    r = Plaintext::Resolver.new(file, 'text/plain')
    r.max_plaintext_bytes = 3
    expect(r.text).to eq "lor"
  end

  it 'Should return a utf8 encoded string' do
    file = File.new('spec/fixtures/files/text.txt', 'r')
    expect(subject.text(file).encoding.name).to eq 'UTF-8'
  end


end
