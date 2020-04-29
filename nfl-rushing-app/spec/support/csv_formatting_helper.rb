require 'csv'

module CsvFormattingHelper
  def format_for_csv_output(player, csv_headers_map)
    CSV.generate_line(
      csv_headers_map.map do |header, col|
        case header
        when 'Player'
          player.name
        when 'Team'
          player.team.name
        when 'Pos'
          player.position.name
        else
          player.rushing.send(col)
        end
      end
    )
  end
end
