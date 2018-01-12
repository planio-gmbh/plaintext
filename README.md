# Text-Extractor

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
- Comma separated vector (csv)

## Acknowledgemts

This gem bases on work by Jens Krämer / Planio, who originally provided it as a
[patch for Redmine](https://www.redmine.org/issues/306). Now, it is a collaborative effort of
both project management software providers [Planio](https://plan.io) and [OpenProject](https://openproject.org)
as both systems tackle the identical challenge to extract plain text from attachment files.

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

On Mac things are still not complete. Please help us to have the same capabilities as under Linux. Right now we cannot
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

## License

The `text-extractor` gem is free software; you can redistribute it and/or modify it under the terms of the GNU General 
Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any 
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied 
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with the plugin. If not, see
[www.gnu.org/licenses](https://www.gnu.org/licenses/).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/planio-gmbh/text-extractor.

