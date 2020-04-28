require 'json_parser'

module JsonParserWrapper
  def self.parse_json_for_database_insertion(json_file_name, verbose = false)
    json_parser = JsonParser.new
    File.open(json_file_name, 'r').each(nil, 1024) { |chunk| json_parser.receive_data(chunk) }
    #File.open(json_file_name, 'r') do |f|
    #  f.seek(1, IO::SEEK_CUR) # skip the array character so we can get each individual object
    #  json_parser.receive_data(f.read(1024)) until f.eof?
    #end
  end
end
