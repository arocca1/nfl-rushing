# == Schema Information
#
# Table name: teams
#
#  id   :bigint           not null, primary key
#  name :string           not null
#
class Team < ApplicationRecord
  has_many :players, inverse_of: :team

  validates :name, uniqueness: true
end
