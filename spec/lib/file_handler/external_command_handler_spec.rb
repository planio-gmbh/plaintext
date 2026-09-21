# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::ExternalCommandHandler do

  subject { passthrough_handler }

  if File.executable?('/bin/cat')
    it 'Should keep non-ASCII characters of the command output intact' do
      file = File.new('spec/fixtures/files/text-with-umlaut.txt', 'r')

      expect(subject.text(file, max_size: 4096))
        .to match /In der Küche hat es eine Kaffeemaschine, mañana habrá café/
    end

    it 'Should return a utf8 encoded string' do
      file = File.new('spec/fixtures/files/text-with-umlaut.txt', 'r')

      expect(subject.text(file, max_size: 4096).encoding.name).to eq 'UTF-8'
      expect(subject.text(file).encoding.name).to eq 'UTF-8'
    end

    # the size limit is applied to the raw byte stream, so it may well cut
    # through a multi byte character
    it 'Should only replace the character the size limit cuts in half' do
      file = File.new('spec/fixtures/files/text-with-umlaut.txt', 'r')

      # 57 bytes covers everything up to and including the first byte of the
      # 'ñ' in 'mañana'
      text = subject.text(file, max_size: 57)

      expect(text).to eq 'lorem ipsum In der Küche hat es eine Kaffeemaschine, ma?'
      expect(text).to be_valid_encoding
    end
  else
    warn "#{described_class.name} could not be tested as /bin/cat is not available."
  end

  it 'Should raise if the command exits with a non-zero status' do
    failing_handler = Class.new(described_class) do
      def initialize
        @content_type = 'text/plain'
        @command = ['/bin/sh', '-c', 'exit 3', Plaintext::ExternalCommandHandler::FILE_PLACEHOLDER]
      end
    end.new
    file = File.new('spec/fixtures/files/text.txt', 'r')

    expect { failing_handler.text(file) }
      .to raise_error(Plaintext::CommandFailed, %r{/bin/sh -c exit 3 .*text\.txt failed: pid \d+ exit 3})
  end
end
