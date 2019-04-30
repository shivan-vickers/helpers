# frozen_string_literal: true

files = Dir.glob('**/*.rb')

files.each do |filename|
  next if File.basename(filename) == File.basename(__FILE__)

  File.open(filename) do |file|
    notes = []

    file.each_line do |line|
      next unless line.include?('# TODO: ')     ||
                  line.include?('# FIXME: ')    ||
                  line.include?('# OPTIMIZE: ') ||
                  line.include?('# REVIEW: ')   ||
                  line.include?('# HACK: ')     ||
                  line.include?('#   ')

      padding = ' ' * (5 - file.lineno.to_s.length)
      notes << "#{padding}#{file.lineno} |#{line.strip.sub('#', '')}"
    end

    unless notes.empty?
      puts ''
      puts " line | #{filename}"
      puts " -----|#{'-' * 79}"
      puts notes
      puts ''
    end
  end
end
