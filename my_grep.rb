#!/usr/bin/env ruby

require_relative 'lib/parameters_parsing'
require_relative 'lib/grep'

parameters_parsing = ParametersParsing.new(ARGV)

grep = Grep.new(parameters_parsing.all_args)
grep.process
