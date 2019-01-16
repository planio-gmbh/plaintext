# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::PptxHandler do

  subject { described_class.new }

  it 'Should extract text from .pptx files' do
    file = File.new('spec/fixtures/files/presentation.pptx', 'r')


    expect(subject.text(file)).to match /Slide two/

    expect(Plaintext::Resolver.new(file, 'application/vnd.openxmlformats-officedocument.presentationml.presentation').text).to(
        match /The Title find me Slide two/
    )
    expect(Plaintext::Resolver.new(file, 'application/vnd.openxmlformats-officedocument.presentationml.slideshow').text).to(
        match /The Title find me Slide two/
    )
    expect(Plaintext::Resolver.new(file, 'application/vnd.ms-powerpoint.template.macroEnabled.12').text).to(
        match /The Title find me Slide two/
    )
  end

  it 'Should only extract text up to given size limit' do
    file = File.new('spec/fixtures/files/presentation.pptx', 'r')
    expect(subject.text(file, max_size: 2)).to eq "Th"

    r = Plaintext::Resolver.new(file, 'application/vnd.openxmlformats-officedocument.presentationml.presentation')
    r.max_plaintext_bytes = 3
    expect(r.text).to eq "The"
  end

  it 'Should return a utf8 encoded string' do
    file = File.new('spec/fixtures/files/presentation.pptx', 'r')
    expect(subject.text(file).encoding.name).to eq 'UTF-8'
  end
end
