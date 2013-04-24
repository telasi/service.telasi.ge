# encoding: utf-8
require 'c12-commons'

text = IO.read("test.txt").to_ka(true)
IO.write("translated.txt", text)
