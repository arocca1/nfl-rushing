require "rails_helper"

RSpec.describe JsonParser, type: :helper do
  describe "parsing" do
    let(:joe_banyard) {
      {
        "Player":"Joe Banyard",
        "Team":"JAX",
        "Pos":"RB",
        "Att":2,
        "Att/G":2,
        "Yds":7,
        "Avg":3.5,
        "Yds/G":7,
        "TD":0,
        "Lng":"7",
        "1st":0,
        "1st%":0,
        "20+":0,
        "40+":0,
        "FUM":0
      }
    }
    let(:shaun_hill) {
      {
        "Player":"Shaun Hill",
        "Team":"MIN",
        "Pos":"QB",
        "Att":5,
        "Att/G":1.7,
        "Yds":5,
        "Avg":1,
        "Yds/G":1.7,
        "TD":0,
        "Lng":"9",
        "1st":0,
        "1st%":0,
        "20+":0,
        "40+":0,
        "FUM":0
      }
    }
    let(:all_day) {
      {
        "Player":"Adrian Peterson",
        "Team":"MIN",
        "Pos":"RB",
        "Att":37,
        "Att/G":12.3,
        "Yds":"72",
        "Avg":1.9,
        "Yds/G":24,
        "TD":0,
        "Lng":"13T",
        "1st":3,
        "1st%":8.1,
        "20+":0,
        "40+":0,
        "FUM":1
      }
    }
    let(:raw_data_diff_team) {
      [
        joe_banyard,
        shaun_hill,
      ].to_json
    }
    let(:raw_data_same_team) {
      [
        joe_banyard,
        shaun_hill,
        all_day,
      ].to_json
    }

    def format_rushing_output(expected_rushing_output)
      expected_rushing_output.reduce({}) do |memo, (k, v)|
        key = Rushing::DISPLAY_NAME_TO_COLUMN[k]
        case key
        when :attempts_per_game, :yards_per_game, :first_down_percentage
          memo.merge({ key => v.to_f })
        when :yards
          memo.merge({ key => v.to_i })
        when :longest
          is_longest_td = v[-1] == 'T'
          value = (is_longest_td ? v[..-2] : v).to_i
          memo.merge({ key => value, is_longest_td: is_longest_td })
        when nil
          memo
        else
          memo.merge({ key => v })
        end
      end
    end

    def run_parsing(data)
      parser = JsonParser.new
      step = 100
      (data.length * 1.0 / step).ceil.times do |i|
        parser.receive_data(data[i*step..i*step+step-1])
      end
    end

    it 'creates the players and teams from the JSON' do
      run_parsing(raw_data_diff_team)
      # want to make sure that the teams, positions, and players were each created
      expect(Player.all.pluck(:name)).to match_array(["Joe Banyard", "Shaun Hill"])
      expect(Team.all.pluck(:name)).to match_array(["JAX", "MIN"])
      expect(Position.all.pluck(:name)).to match_array(["RB", "QB"])
      # verify the rushing stats
      [
        ["Joe Banyard", "JAX", "RB", joe_banyard],
        ["Shaun Hill", "MIN", "QB", shaun_hill],
      ].each do |name, team, pos, expected_rushing_output|
        player = Player.find_by(name: name)
        expect(player.team.name).to eq(team)
        expect(player.position.name).to eq(pos)
        player_rushing_stat = player.rushing
        expect(player_rushing_stat.attributes.symbolize_keys.slice(*(Rushing::COLUMN_TO_DISPLAY_NAME.keys + [:is_longest_td])))
          .to eq(format_rushing_output(expected_rushing_output))
      end
    end

    it 'creates the players and teams from the JSON, but not duplicate teams' do
      run_parsing(raw_data_same_team)
      # want to make sure that the teams, positions, and players were each created
      expect(Player.all.pluck(:name)).to match_array(["Joe Banyard", "Shaun Hill", "Adrian Peterson"])
      expect(Team.all.pluck(:name)).to match_array(["JAX", "MIN"])
      expect(Position.all.pluck(:name)).to match_array(["RB", "QB"])
      # verify the rushing stats
      [
        ["Joe Banyard", "JAX", "RB", joe_banyard],
        ["Shaun Hill", "MIN", "QB", shaun_hill],
        ["Adrian Peterson", "MIN", "RB", all_day],
      ].each do |name, team, pos, expected_rushing_output|
        player = Player.find_by(name: name)
        expect(player.team.name).to eq(team)
        expect(player.position.name).to eq(pos)
        player_rushing_stat = player.rushing
        expect(player_rushing_stat.attributes.symbolize_keys.slice(*(Rushing::COLUMN_TO_DISPLAY_NAME.keys + [:is_longest_td])))
          .to eq(format_rushing_output(expected_rushing_output))
      end
    end

    it 'does not create new team, player, or rushing records for updates' do
      run_parsing(raw_data_diff_team)
      # run the parsing again (this could be part of a weekly job)
      run_parsing(raw_data_diff_team)
      # want to make sure that the teams, positions, and players were each created
      expect(Player.all.pluck(:name)).to match_array(["Joe Banyard", "Shaun Hill"])
      expect(Team.all.pluck(:name)).to match_array(["JAX", "MIN"])
      expect(Position.all.pluck(:name)).to match_array(["RB", "QB"])
      # verify the rushing stats
      [
        ["Joe Banyard", "JAX", "RB", joe_banyard],
        ["Shaun Hill", "MIN", "QB", shaun_hill],
      ].each do |name, team, pos, expected_rushing_output|
        player = Player.find_by(name: name)
        expect(player.team.name).to eq(team)
        expect(player.position.name).to eq(pos)
        player_rushing_stat = player.rushing
        expect(player_rushing_stat.attributes.symbolize_keys.slice(*(Rushing::COLUMN_TO_DISPLAY_NAME.keys + [:is_longest_td])))
          .to eq(format_rushing_output(expected_rushing_output))
      end
    end

    it 'does not create new team, player, or rushing records for a player changing teams' do
      run_parsing(raw_data_diff_team)
      joe_banyard_on_new_team = joe_banyard.merge({ Team: "BUF", Att: 10, Yds: 75 })
      run_parsing([joe_banyard_on_new_team, shaun_hill].to_json)
      # want to make sure that the teams, positions, and players were each created
      expect(Player.all.pluck(:name)).to match_array(["Joe Banyard", "Shaun Hill"])
      expect(Team.all.pluck(:name)).to match_array(["JAX", "MIN", "BUF"])
      expect(Position.all.pluck(:name)).to match_array(["RB", "QB"])
      # verify the rushing stats
      [
        ["Joe Banyard", "BUF", "RB", joe_banyard_on_new_team],
        ["Shaun Hill", "MIN", "QB", shaun_hill],
      ].each do |name, team, pos, expected_rushing_output|
        player = Player.find_by(name: name)
        expect(player.team.name).to eq(team)
        expect(player.position.name).to eq(pos)
        player_rushing_stat = player.rushing
        expect(player_rushing_stat.attributes.symbolize_keys.slice(*(Rushing::COLUMN_TO_DISPLAY_NAME.keys + [:is_longest_td])))
          .to eq(format_rushing_output(expected_rushing_output))
      end
    end
  end
end
