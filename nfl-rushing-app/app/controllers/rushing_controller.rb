require 'will_paginate'

class RushingController < ApplicationController
  RUSHING_SELECT = "rushings.*, players.name AS name, teams.name AS team_name, positions.name AS pos"
  RUSHING_DOWNLOAD_FORMATTERS = {
    csv: RushingCsvFormatter,
  }

  def show_stats
    # expect params of :page_num, :order_dir, :page_size, :sort_by, :query
    stats = Rushing.joins(:player).joins(player: [:team, :position])

    if params[:sort_by] && params[:order_dir] && Rushing.sortable_columns.include?(params[:sort_by].to_sym)
      rushing_col = Rushing.arel_table[params[:sort_by].to_sym]
      if params[:order_dir].to_sym == :asc
        stats = stats.order(rushing_col.asc)
      else
        stats = stats.order(rushing_col.desc)
      end
    end

    # although this looks like a SQL injection, it's not. matches sanitizes
    stats = stats.where(Player.arel_table[:name].matches("%#{params[:query]}%")) if params[:query]

    respond_to do |format|
      format.json do
        # no need to explicitly stream this block explicitly since we are paginating at the database level
        res = {
          stats: stats.paginate(page: params[:page_num], per_page: params[:page_size])
                      .select(RUSHING_SELECT),
          enable_back: params[:page_num].to_i > 1,
          enable_next: params[:page_num].to_i < (stats.count * 1.0 / params[:page_size].to_i).ceil,
        }
        return render json: res
      end
      format.csv do
        formatter = RUSHING_DOWNLOAD_FORMATTERS[:csv]
        if formatter
          generation_time = Time.zone.now.ctime.to_s
          headers.delete("Content-Length")
          headers["Cache-Control"] = "no-cache"
          headers["X-Accel-Buffering"] = "no"
          headers["Content-Type"] = "text/csv"
          headers["Last-Modified"] = generation_time
          self.response_body = formatter.build_csv_enumerator(stats.select(RUSHING_SELECT))
        end
      end
    end
  end
end
