# frozen_string_literal: true

require 'spec_helper'

describe Plaintext::ImageHandler do

  subject { described_class.new }

  if described_class.available?
    it 'Should extract text from png files' do
      file = File.new('spec/fixtures/files/image.png', 'r')

      expect(subject.text(file)).to match /Enable two-factor authentication/
    end
    it 'Should extract text from jpeg files' do
      file = File.new('spec/fixtures/files/image.jpg', 'r')

      expect(subject.text(file)).to match /Enable two-factor authentication/
    end
    it 'Should extract text from tiff files' do
      file = File.new('spec/fixtures/files/image.tiff', 'r')

      expect(subject.text(file)).to match /Enable two-factor authentication/
      expect(Plaintext::Resolver.new(file, 'image/tiff').text).to match /zeee spbp 7uhp hc7s/
    end
    it 'Should extract empty text from images without text' do
      file = File.new('spec/fixtures/files/image-without-text.jpg', 'r')

      expect(subject.text(file)).to be_empty
      expect(Plaintext::Resolver.new(file, 'image/jpeg').text).to be_empty
    end
  else
    warn "#{described_class.name} could not be tested as external program is not available."
  end
end
