require 'csv'
require 'will_paginate'

class RushingCsvFormatter < RushingDownloadFormatter
  # doesn't have to match any of the front-end paging; this is more for batching sake
  PAGE_SIZE = 100

  def self.build_csv_enumerator(player_rushing_relation, select_clause, order_clause)
    csv_columns = {
      'Player' => :name,
      'Team' => :team_name,
      'Pos' => :pos,
    }.merge(Rushing::DISPLAY_NAME_TO_COLUMN)
    Enumerator.new do |y|
      y << CSV.generate_line(csv_columns.keys)
      (player_rushing_relation.count * 1.0 / PAGE_SIZE).ceil.times do |page|
        query = player_rushing_relation.select(select_clause).paginate(page: page + 1, per_page: PAGE_SIZE)
        query = query.order(order_clause) if !order_clause.nil?
        query.each { |rushing_stat| y << CSV.generate_line(rushing_stat.slice(*csv_columns.invert.keys).values) }
      end
    end
  end
end
