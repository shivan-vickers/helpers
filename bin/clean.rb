# frozen_string_literal: true

require 'fileutils'

directories_to_clean = [
  'dump/local',
  'dump/server',
  'dump/comp'
]

unless ARGV.empty?
  directories_to_clean = ARGV.dup
  ARGV.clear
end

DEFAULT_BASE_DIR = File.expand_path "#{__dir__}/.."

directories_to_clean.each do |dir|
  dir = File.expand_path dir, DEFAULT_BASE_DIR

  Dir.glob("#{dir}/*").each do |item|
    begin
      FileUtils.remove_entry_secure(item)
      puts "deleted: #{item.sub DEFAULT_BASE_DIR, ''}"
    rescue Errno::ENOENT
      puts "failed to delete #{item}"
    end
  end
end

puts 'Finished!'
