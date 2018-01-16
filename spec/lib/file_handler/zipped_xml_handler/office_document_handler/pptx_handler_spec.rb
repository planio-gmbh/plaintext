# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::PptxHandler do

  subject { described_class.new }

  it 'Should extract text from .pptx files' do
    file = File.new('spec/fixtures/files/presentation.pptx', 'r')


    expect(subject.text(file)).to match /Slide two/

    expect(TextExtractor::Resolver.new(file, 'application/vnd.openxmlformats-officedocument.presentationml.presentation').text).to(
        match /The Title find me Slide two/
    )
    expect(TextExtractor::Resolver.new(file, 'application/vnd.openxmlformats-officedocument.presentationml.slideshow').text).to(
        match /The Title find me Slide two/
    )
    expect(TextExtractor::Resolver.new(file, 'application/vnd.ms-powerpoint.template.macroEnabled.12').text).to(
        match /The Title find me Slide two/
    )
  end
end