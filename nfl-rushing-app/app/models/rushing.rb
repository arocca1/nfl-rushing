# == Schema Information
#
# Table name: rushings
#
#  id                    :bigint           not null, primary key
#  attempts_per_game     :float
#  attempts              :integer
#  yards                 :integer
#  yards_per_attempt     :float
#  yards_per_game        :float
#  tds                   :integer
#  longest               :integer
#  is_longest_td         :boolean
#  first_downs           :integer
#  first_down_percentage :float
#  runs_twenty_plus      :integer
#  runs_forty_plus       :integer
#  fumbles               :integer
#  player_id             :bigint           not null
#
class Rushing < ApplicationRecord
  belongs_to :player, inverse_of: :rushing

  COLUMN_TO_DISPLAY_NAME = {
    attempts_per_game: :'Att/G',
    attempts: :Att,
    yards: :Yds,
    yards_per_attempt: :Avg,
    yards_per_game: :'Yds/G',
    tds: :TD,
    longest: :Lng,
    first_downs: :'1st',
    first_down_percentage: :'1st%',
    runs_twenty_plus: :'20+',
    runs_forty_plus: :'40+',
    fumbles: :FUM,
  }
  DISPLAY_NAME_TO_COLUMN = COLUMN_TO_DISPLAY_NAME.invert

  def self.sortable_columns
    [:yards, :longest, :tds]
  end
end
