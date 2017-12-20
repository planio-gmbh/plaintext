# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'text_extractor/version'

Gem::Specification.new do |spec|
  spec.name          = "text-extractor"
  spec.version       = TextExtractor::VERSION
  spec.authors       = ["Wieland Lindenthal"]
  spec.email         = ["w.lindenthal@forkmerge.com"]

  spec.summary       = "Extract text from docuements"
  spec.description   = "Extract text from common office files. Based on the file's content type a command line tool is selected to do the job."
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rubyzip', '~> 1.2.1'
  spec.add_dependency 'nokogiri', '~> 1.8.1'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
