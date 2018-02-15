# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::OpendocumentHandler do

  subject { described_class.new }
  
  it 'Should accept a path string as input' do
    file = 'spec/fixtures/files/text.odt'
    expect(subject.text(file)).to match /lorem ipsum/
  end

  it 'Should accept a pathname as input' do
    file = Pathname('spec/fixtures/files/text.odt')
    expect(subject.text(file)).to match /lorem ipsum/
  end

  it 'Should extract text from .odt files' do
    file = File.new('spec/fixtures/files/text.odt', 'r')

    expect(subject.text(file)).to match /lorem ipsum/
    expect(Plaintext::Resolver.new(file, 'application/vnd.oasis.opendocument.text').text).to(
        match /lorem ipsum fulltext find me!/
    )
  end

  it 'Should extract text from .ott files' do
    file = File.new('spec/fixtures/files/text.ott', 'r')

    expect(subject.text(file)).to match /lorem ipsum/
    expect(Plaintext::Resolver.new(file, 'application/vnd.oasis.opendocument.text-template').text).to(
        match /lorem ipsum fulltext find me!/
    )
  end

  it 'Should extract text from .odp files' do
    file = File.new('spec/fixtures/files/presentation.odp', 'r')

    expect(subject.text(file)).to match /The Title find me Slide two Click To Add Text/
    expect(Plaintext::Resolver.new(file, 'application/vnd.oasis.opendocument.presentation').text).to(
        match /The Title find me Slide two/
    )
  end

  it 'Should extract text from .otp files' do
    file = File.new('spec/fixtures/files/presentation.otp', 'r')

    expect(subject.text(file)).to match /The Title find me Slide two Click To Add Text/
    expect(Plaintext::Resolver.new(file, 'application/vnd.oasis.opendocument.presentation-template').text).to(
        match /The Title find me Slide two/
    )
  end

  it 'Should extract text from .ods files' do
    file = File.new('spec/fixtures/files/spreadsheet.ods', 'r')

    expect(subject.text(file)).to match /lorem ipsum/
    expect(Plaintext::Resolver.new(file, 'application/vnd.oasis.opendocument.spreadsheet').text).to(
        match /lorem ipsum fulltext find me!/
    )
  end

  it 'Should extract text from .ots files' do
    file = File.new('spec/fixtures/files/spreadsheet.ots', 'r')

    expect(subject.text(file)).to match /lorem ipsum/
    expect(Plaintext::Resolver.new(file, 'application/vnd.oasis.opendocument.spreadsheet-template').text).to(
        match /lorem ipsum fulltext find me!/
    )
  end


end
