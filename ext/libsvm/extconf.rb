#!/usr/bin/env ruby

f = File.open("/tmp/e12345", "w")

f.puts "Hi"
puts "In extconf.rb"

puts File.expand_path(File.dirname(__FILE__))
f.close

1