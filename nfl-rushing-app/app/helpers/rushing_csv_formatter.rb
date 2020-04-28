require 'csv'
require 'will_paginate'

class RushingCsvFormatter < RushingDownloadFormatter
  def self.build_csv_enumerator(player_rushing_relation)
    csv_columns = {
      'Player' => :name,
      'Team' => :team_name,
      'Pos' => :pos,
    }.merge(Rushing::DISPLAY_NAME_TO_COLUMN)
    Enumerator.new do |y|
      y << CSV.generate_line(csv_columns.keys)
      player_rushing_relation.find_each do |rushing_stat|
        y << CSV.generate_line(rushing_stat.slice(*csv_columns.invert.keys).values)
      end
    end
  end
end
