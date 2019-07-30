# frozen_string_literal: true

require 'base64'
require 'clipboard'

str = ARGV.shift

decoded = Base64.decode64 str

Clipboard.copy decoded

puts decoded
