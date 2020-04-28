# == Schema Information
#
# Table name: positions
#
#  id   :bigint           not null, primary key
#  name :string           not null
#
class Position < ApplicationRecord
  has_many :players, inverse_of: :position
end
