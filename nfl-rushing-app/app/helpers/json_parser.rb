require 'yajl'

# assume loaded in Rails environment
class JsonParser
  def initialize
    @parser = Yajl::Parser.new(symbolize_keys: true)
    # once a full JSON object has been parsed from the stream
    # object_parsed will be called, and passed the constructed object
    @parser.on_parse_complete = method(:object_parsed)
  end

  def object_parsed(obj)
    obj.each do |player_stat|
      team = Team.find_or_create_by(name: player_stat[:Team])
      position = Position.find_or_create_by(name: player_stat[:Pos])
      player = position.players.find_or_create_by(name: player_stat[:Player])
      # player could be on different team
      player.update(team_id: team.id)
      rushing = Rushing.find_or_initialize_by(player_id: player.id)
      Rushing::DISPLAY_NAME_TO_COLUMN.each do |display_name, col|
        if display_name == :Lng
          rushing.is_longest_td = player_stat[:Lng][-1] == 'T'
          rushing.longest = (rushing.is_longest_td ? player_stat[:Lng][..-2] : player_stat[:Lng]).to_i
        else
          rushing.send("#{col}=", player_stat[display_name])
        end
      end
      rushing.save
    end
  end

  def receive_data(data)
    # continue passing chunks
    @parser << data
  end
end
