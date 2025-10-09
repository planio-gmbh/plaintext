# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::Resolver do
  it 'can deal with frozen string returned by the handler' do
    file = File.new('spec/fixtures/files/text.txt', 'r')
    resolver = described_class.new(file, 'text/plain')

    # make the handler return a frozen string
    handler = resolver.send(:find_handler)
    allow(handler).to receive(:text).and_wrap_original { |m, *args| m.call(*args).freeze }

    expect(resolver.text).to match(/lorem ipsum/)
  end
end
