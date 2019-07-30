# frozen_string_literal: true

require 'base64'
require 'clipboard'

str = ARGV.shift

encoded = Base64.strict_encode64 str

Clipboard.copy encoded

puts encoded
