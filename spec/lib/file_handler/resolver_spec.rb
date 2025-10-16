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
