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
end