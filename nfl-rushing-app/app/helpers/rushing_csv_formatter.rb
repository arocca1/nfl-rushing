require 'csv'

class BatchedCsvBuilder
  attr_accessor :csv_columns, :player_rushing_relation, :output

  def initialize(csv_columns, player_rushing_relation, output = "")
    @csv_columns = csv_columns
    @player_rushing_relation = data
    @output = output
  end

  def build
    output << CSV.generate_line(csv_columns.keys)
    player_rushing_relation.find_each do |rushing_stat|
      output << CSV.generate_line(rushing_stat.slice(*csv_columns.invert.keys).values)
    end
    output
  end
end

module RushingCsvFormatter
  def self.build_csv_enumerator(player_rushing_relation)
    csv_columns = Rushing::DISPLAY_NAME_TO_COLUMN.merge({
      'Player' => :name,
      'Team' => :team_name,
      'Pos' => :pos,
    })
    Enumerator.new do |y|
      BatchedCsvBuilder.new(csv_columns, player_rushing_relation, y)
    end
  end
end
