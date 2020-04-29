require 'csv'
require 'will_paginate'

class RushingCsvFormatter < RushingDownloadFormatter
  # doesn't have to match any of the front-end paging; this is more for batching sake
  PAGE_SIZE = 100

  def self.get_csv_header
    ActiveSupport::OrderedHash.new.merge({
      'Player' => :name,
      'Team' => :team_name,
      'Pos' => :pos,
    }).merge(Rushing::DISPLAY_NAME_TO_COLUMN)
  end

  def self.get_rushing_stat_value(rushing_stat, csv_headers_map)
    csv_headers_map.map { |header, col| rushing_stat.send(col) }
  end

  def self.build_csv_enumerator(player_rushing_relation, select_clause, order_clause)
    csv_headers_map = self.get_csv_header
    Enumerator.new do |y|
      y << CSV.generate_line(csv_headers_map.keys)
      (player_rushing_relation.count * 1.0 / PAGE_SIZE).ceil.times do |page|
        query = player_rushing_relation.select(select_clause).paginate(page: page + 1, per_page: PAGE_SIZE)
        query = query.order(order_clause) if !order_clause.nil?
        query.each { |rushing_stat| y << CSV.generate_line(self.get_rushing_stat_value(rushing_stat, csv_headers_map)) }
      end
    end
  end
end
