# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::Resolver do
  subject(:resolver) do
    file = File.new('spec/fixtures/files/text.txt', 'r')
    described_class.new(file, 'text/plain')
  end
  let(:handler) { resolver.send(:find_handler) }

  it 'squishes and strips the text returned by the handler' do
    allow(handler).to receive(:text).and_return("  hello \n \n world! ")

    expect(resolver.text).to eq("hello world!")
  end

  it 'keeps the whitespace returned by the handler if preserve_whitespace is set' do
    allow(handler).to receive(:text).and_return("  hello \n \n world! ")
    resolver.preserve_whitespace = true

    expect(resolver.text).to eq("  hello \n \n world! ")
  end

  it 'still composes and limits the text if preserve_whitespace is set' do
    # 'u' followed by a combining diaeresis
    allow(handler).to receive(:text).and_return("In der Küche\n\nist es warm")
    resolver.preserve_whitespace = true
    resolver.max_plaintext_bytes = 14

    expect(resolver.text).to eq "In der Küche\n"
  end

  it 'composes decomposed characters' do
    # 'u' followed by a combining diaeresis
    allow(handler).to receive(:text).and_return("In der Küche")

    expect(resolver.text).to eq "In der Küche"
  end

  it 'limits the text to max_plaintext_bytes without splitting a character' do
    allow(handler).to receive(:text).and_return("In der Küche")
    resolver.max_plaintext_bytes = 9

    # the 'ü' starts at byte 8 and would not fit into the limit
    expect(resolver.text).to eq 'In der K'
  end

  it 'returns nil if the handler returns nil' do
    allow(handler).to receive(:text).and_return(nil)

    expect(resolver.text).to be_nil
  end

  it 'can deal with frozen string returned by the handler' do
    # make the handler return a frozen string
    allow(handler).to receive(:text).and_wrap_original { |m, *args| m.call(*args).freeze }

    expect(resolver.text).to match(/lorem ipsum/)
  end
end
