# frozen_string_literal: true

require 'optparse'

files_to_search = Dir.glob('**/*').reject { |e| File.directory? e }

case_sensitive = nil

parser = OptionParser.new

parser.banner = 'Usage: hunt STRING [options]'

parser.on('-i', '--include=PATH', 'Search only files or directories matching PATH') do |p|
  files_to_search.select! { |f| f.include? p }
end

parser.on('-x', '--exclude=PATH', 'Exclude files or directories matching PATH') do |p|
  files_to_search.reject! { |f| f.include? p }
end

parser.on('-c', '--case-sensitive', 'Run a case sensitive search') do
  case_sensitive = true
end

parser.on('-h', '--help', 'Print this help') do
  puts parser
  exit
end

if ARGV.empty?
  puts parser
  exit
end

parser.parse!

target_string = ARGV.shift

target_string = target_string.downcase unless case_sensitive

total_matches = 0

files_to_search.each do |filename|
  next if File.basename(filename) == File.basename(__FILE__)

  File.open(filename) do |file|
    matches = []

    file.each_line do |line|
      line = line.downcase unless case_sensitive

      next unless line.include?(target_string)

      padding = ' ' * (5 - file.lineno.to_s.length)
      matches << "#{padding}#{file.lineno}| #{line.strip[0..79]}"
    end

    unless matches.empty?
      puts "\n line| #{filename}"
      puts " ----|#{'-' * 81}"
      puts matches
      puts ''
    end

    total_matches += matches.count
  end
end

puts "TOTAL MATCHES: #{total_matches}"
