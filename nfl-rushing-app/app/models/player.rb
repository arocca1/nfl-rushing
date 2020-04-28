# == Schema Information
#
# Table name: players
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  team_id     :bigint           not null
#  position_id :bigint           not null
#
class Player < ApplicationRecord
  belongs_to :team, inverse_of: :players
  belongs_to :position, inverse_of: :players
  has_one :rushing, inverse_of: :player
end
