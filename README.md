# Textextractor

This gem wraps command line tools to extract plain text from typical files such as

- PDF
- UTF
- MS Office
    - Word (doc, docx)
    - Excel (xsl, xslx)
    - PowerPoint (ppt, pptx)
- OpenOffice + Libre
    - Presentation
    - Text
    - Spreadsheet
- Plaintext (txt)

## Acknowledgemts

This gem was extracted from a work by Jens Krämer / Planio, which they provided as a patch for Redmine. Thank you, guys!
https://www.redmine.org/issues/306

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'text-extractor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install text-extractor

#### Rails

In a Rails application save `text-extractor.yml.example` in `config/text-extractor.yml` and overwrite the settings to 
your needs.

#### Plain Ruby

Please overwrite `TextExtractor::Configuration.load`.

### Linux

On linux the default configuration should work. However, make sure that the following packages are installed

    $ apt-get install catdoc unrtf poppler-utils

### Mac OS X

On Mac things are still not complete. Please help us to have the same capabilities as under Linux. Right now we cannot\
extract text from presentation and spreadsheets.

Please use homebrew to install the missing command line tools.

    $ brew install poppler
    $ brew install unrtf
    
The `text-extraction.yml` should look like this:
    
```yml
text_extractors:
  pdftotext:
   - /usr/local/bin/pdftotext
   - -enc
   - UTF-8
   - __FILE__
   - '-'

  unrtf:
    - /usr/local/bin/unrtf
    - --text
    - __FILE__

  catdoc:
    - /usr/bin/textutil
    - -convert
    - txt
    - -stdout
    - __FILE__
```

## Usage

```ruby
# `file` is of type File.
# `content_type` is a String.
fulltext = TextExtractor::Resolver.new(file, content_type).text
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/opf/text-extractor.

