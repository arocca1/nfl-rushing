class Rushing < ApplicationRecord
  COLUMN_TO_DISPLAY_NAME = {
    attempts_per_game: 'Att/G',
    attempts: 'Att',
    yards: 'Yds',
    yards_per_attempt: 'Avg',
    yards_per_game: 'Yds/G',
    tds: 'TD',
    longest: 'Lng',
    first_downs: '1st',
    first_down_percentage: '1st%',
    runs_twenty_plus: '20+',
    runs_forty_plus: '40+',
    fumbles: 'FUM',
  }

  def self.sortable_columns
    [:yards, :longest, :tds]
  end
end
