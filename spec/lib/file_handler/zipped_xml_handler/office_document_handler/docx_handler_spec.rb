# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::DocxHandler do

  subject { described_class.new }

  it 'Should extract text from .docx files' do
    file = File.new('spec/fixtures/files/text.docx', 'r')

    expect(subject.text(file)).to(
      match /lorem ipsum/
    )
    expect(Plaintext::Resolver.new(file, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document').text).to(
      match /lorem ipsum fulltext find me!/
    )
  end

  it 'Should only extract text up to given size limit' do
    file = File.new('spec/fixtures/files/text.docx', 'r')
    expect(subject.text(file, max_size: 2)).to eq "lo"

    r = Plaintext::Resolver.new(file, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document')
    r.max_plaintext_bytes = 3
    expect(r.text).to eq "lor"
  end

  it 'Should return a utf8 encoded string' do
    file = File.new('spec/fixtures/files/text.docx', 'r')
    expect(subject.text(file).encoding.name).to eq 'UTF-8'
  end
end
