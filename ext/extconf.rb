#!/usr/bin/env ruby

f = File.open("/tmp/e12345", "w")

f.puts "Hi"
puts "In extconf.rb"

f.close