# frozen_string_literal: true

abort 'arg missing' if ARGV.empty?

target_string = ARGV.shift.downcase

files_to_ignore = ARGV.dup
ARGV.clear

files = Dir.glob('**/*').reject { |f| File.directory? f }

total_matches = 0

files.each do |filename|
  next if File.basename(filename) == File.basename(__FILE__)

  next if files_to_ignore.any? { |f| filename.include? f }

  File.open(filename) do |file|
    matches = []

    file.each_line do |line|
      next unless line.downcase.include?(target_string)

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
