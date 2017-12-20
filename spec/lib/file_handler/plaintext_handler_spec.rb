#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2017 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

# frozen_string_literal: true

require 'spec_helper'

describe TextExtractor::Resolver::PlaintextHandler do

  subject { described_class.new }

  it 'Should extract text from .txt files' do
    file = File.new('spec/fixtures/files/text.txt', 'r')
    expect(subject.text(file, 'text/plain')).to match /lorem/
  end

  it 'Should extract text from .csv files' do
    file = File.new('spec/fixtures/files/spreadsheet.csv', 'r')
    expect(subject.text(file, 'text/csv')).to match /lorem/
  end
end