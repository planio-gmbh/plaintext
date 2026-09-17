# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::PdfHandler do

  subject { described_class.new }

  before { described_class.instance_variable_set(:@supports_urls, nil) }

  def command
    described_class.new.instance_variable_get(:@command)
  end

  def stub_config(overrides)
    allow(Plaintext::Configuration).to receive(:[]).and_call_original
    overrides.each do |key, value|
      allow(Plaintext::Configuration).to receive(:[]).with(key).and_return(value)
    end
  end

  describe '.supports_urls?' do
    it 'is true when pdftotext -h advertises the option' do
      allow(File).to receive(:executable?).with('/bin/pdftotext').and_return(true)
      allow(Open3).to receive(:capture2e).with('/bin/pdftotext', '-h').and_return(["  -urls  print the URL\n", nil])

      expect(described_class.supports_urls?('/bin/pdftotext')).to be true
    end

    it 'is false, without spawning a process, for a non-executable binary' do
      allow(File).to receive(:executable?).with('/nope').and_return(false)
      expect(Open3).not_to receive(:capture2e)

      expect(described_class.supports_urls?('/nope')).to be false
    end

    it 'caches the result per binary' do
      allow(File).to receive(:executable?).and_return(true)
      allow(Open3).to receive(:capture2e).and_return(['-urls', nil])

      2.times { described_class.supports_urls?('/bin/pdftotext') }

      expect(Open3).to have_received(:capture2e).once
    end

    it 'is false when the probe raises a SystemCallError' do
      allow(File).to receive(:executable?).and_return(true)
      allow(Open3).to receive(:capture2e).and_raise(Errno::ENOENT)

      expect(described_class.supports_urls?('/bin/pdftotext')).to be false
    end
  end

  context 'when pdftotext supports -urls' do
    before { allow(described_class).to receive(:supports_urls?).and_return(true) }

    it 'passes -urls by default, before the file placeholder' do
      expect(command).to include('-urls')
      expect(command.index('-urls')).to be < command.index(Plaintext::ExternalCommandHandler::FILE_PLACEHOLDER)
    end

    it 'omits -urls when pdftotext_urls is false' do
      stub_config('pdftotext_urls' => false)
      expect(command).not_to include('-urls')
    end

    Plaintext::PdfHandler::URLS_INCOMPATIBLE_FLAGS.each do |flag|
      it "does not add -urls to a command using #{flag}" do
        stub_config('pdftotext' => ['/usr/bin/pdftotext', flag, '__FILE__', '-'])
        expect(command).not_to include('-urls')
      end
    end

    it 'does not duplicate an -urls already present in the command' do
      stub_config('pdftotext' => ['/usr/bin/pdftotext', '-urls', '__FILE__', '-'])
      expect(command.count('-urls')).to eq 1
    end
  end

  context 'with an unusable pdftotext configuration' do
    # No supports_urls? stub here, so the real cheap guards must short-circuit
    # before the version probe runs — otherwise these configurations raise
    # while every handler is built.
    {
      'an empty command' => [],
      'a string command' => '/usr/bin/pdftotext -enc UTF-8 __FILE__ -',
      'a command without the file placeholder' => ['/usr/bin/pdftotext', '-'],
    }.each do |description, config|
      context "with #{description}" do
        before { stub_config('pdftotext' => config) }

        it 'does not raise while the handler is built' do
          expect { described_class.new }.not_to raise_error
        end

        it 'leaves the configured command untouched' do
          expect(command).to eq config
        end
      end
    end
  end

  context 'when pdftotext does not support -urls' do
    before { allow(described_class).to receive(:supports_urls?).and_return(false) }

    it 'does not pass -urls by default' do
      expect(command).not_to include('-urls')
    end

    it 'passes -urls when forced with pdftotext_urls true' do
      stub_config('pdftotext_urls' => true)
      expect(command).to include('-urls')
    end

    it 'treats a non-boolean pdftotext_urls as auto-detection' do
      stub_config('pdftotext_urls' => 'true')
      expect(command).not_to include('-urls')
    end
  end

  if described_class.available?
    it 'Should extract text from .pdf files' do
      file = File.new('spec/fixtures/files/text.pdf', 'r')

      expect(subject.text(file)).to match /lorem ipsum fulltext find me!/
      expect(Plaintext::Resolver.new(file, 'application/pdf').text).to match /lorem ipsum fulltext find me!/
    end

    it 'should extract umlauts correctly into UTF-8' do
      file = File.new('spec/fixtures/files/text-with-umlaut.pdf', 'r')

      expect(subject.text(file)).to match /In der Küche hat es eine Kaffeemaschine/
      expect(Plaintext::Resolver.new(file, 'application/pdf').text).to match /In der Küche hat es eine Kaffeemaschine/
    end

    pdftotext = (Plaintext::Configuration['pdftotext'] || Plaintext::PdfHandler::DEFAULT).first
    if described_class.supports_urls?(pdftotext)
      it 'prints each link URL next to its link text' do
        file = File.new('spec/fixtures/files/text-with-url.pdf', 'r')

        expect(subject.text(file)).to match %r{website today \[https://example\.com/\]}
      end
    else
      warn "#{described_class.name}: installed pdftotext has no -urls option, skipping -urls example."
    end
  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end
