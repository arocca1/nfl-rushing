class CreateRushings < ActiveRecord::Migration[6.0]
  def change
    create_table :rushings do |t|
      t.float :attempts_per_game # Att/G (Rushing Attempts Per Game Average)
      t.integer :attempts # Att (Rushing Attempts)
      t.integer :yards # Yds (Total Rushing Yards)
      t.float :yards_per_attempt # Avg (Rushing Average Yards Per Attempt)
      t.float :yards_per_game # Yds/G (Rushing Yards Per Game)
      t.integer :tds # TD (Total Rushing Touchdowns)
      t.integer :longest # Lng (Longest Rush -- a T represents a touchdown occurred)
      t.boolean :is_longest_td # is the longest run a TD
      t.integer :first_downs # 1st (Rushing First Downs)
      t.float :first_down_percentage # 1st% (Rushing First Down Percentage)
      t.integer :runs_twenty_plus # 20+ (Rushing 20+ Yards Each)
      t.integer :runs_forty_plus # 40+ (Rushing 40+ Yards Each)
      t.integer :fumbles # FUM (Rushing Fumbles)
    end
    add_reference :rushings, :player, foreign_key: true, null: false
  end
end
