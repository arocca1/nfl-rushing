require 'optparse'
require File.expand_path('../../config/environment',  __FILE__)
require 'json_parser_wrapper'

if __FILE__==$0
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: process_rushing_stats_for_database_insertion.rb -f <file to parse> [-v]"

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options[:verbose] = v
    end

    opts.on("-f", "--file FILETOPARSE", "File to parse") do |f|
      options[:file_path] = f
    end
  end.parse!

  JsonParserWrapper.parse_json_for_database_insertion(options[:file_path], options[:verbose])
end
