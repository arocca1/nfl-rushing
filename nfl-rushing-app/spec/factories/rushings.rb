FactoryBot.define do
  factory :rushing do
    attempts { 0 }
    attempts_per_game { 0 }
    yards { 0 }
    yards_per_attempt { 0 }
    yards_per_game { 0 }
    tds { 0 }
    longest { 0 }
    is_longest_td { false }
    first_downs { 0 }
    first_down_percentage { 0 }
    runs_twenty_plus { 0 }
    runs_forty_plus { 0 }
    fumbles { 0 }
    player

    factory :bad_rushing do
      attempts { 5 }
      attempts_per_game { 1.7 }
      yards { 5 }
      yards_per_attempt { 1 }
      yards_per_game { 1.7 }
      tds { 0 }
      longest { 9 }
      is_longest_td { false }
      first_downs { 0 }
      first_down_percentage { 0 }
      runs_twenty_plus { 0 }
      runs_forty_plus { 0 }
      fumbles { 4 }
      player factory: :shaun_hill
    end

    factory :avg_rushing do
      attempts { 75 }
      attempts_per_game { 5 }
      yards { 200 }
      yards_per_attempt { 3 }
      yards_per_game { 40 }
      tds { 2 }
      longest { 43 }
      is_longest_td { false }
      first_downs { 15 }
      first_down_percentage { 5 }
      runs_twenty_plus { 1 }
      runs_forty_plus { 0 }
      fumbles { 2 }
      player factory: :joe_banyard
    end

    factory :good_rushing do
      attempts { 67 }
      attempts_per_game { 13.2 }
      yards { 500 }
      yards_per_attempt { 8.5 }
      yards_per_game { 100 }
      tds { 7 }
      longest { 67 }
      is_longest_td { true }
      first_downs { 10 }
      first_down_percentage { 23.3 }
      runs_twenty_plus { 6 }
      runs_forty_plus { 2 }
      fumbles { 3 }
      player factory: :all_day
    end
  end
end
