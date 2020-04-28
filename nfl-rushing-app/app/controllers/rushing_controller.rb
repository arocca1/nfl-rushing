require 'will_paginate'

class RushingController < ApplicationController
  def show_stats
    # expect params of :page_num, :order_dir, :page_size, :sort_by, :download_format, :query
    stats = Player.joins([:team, :position, :rushing]).paginate(page: params[:page_num], per_page: params[:page_size])

    if params[:sort_by] && params[:order_dir]
      rushing_col = Rushing.arel_table[params[:sort_by].to_sym]
      if params[:order_dir].to_sym == :asc
        stats = stats.order(rushing_col.asc)
      else
        stats = stats.order(rushing_col.desc)
      end
    end

    # although this looks like a SQL injection, it's not. matches sanitizes
    stats = stats.where(Player.arel_table[:name].matches("%#{params[:query]}%")) if params[:query]

    # TODO handle download_format


    # TODO stream this back
    render json: stats, status: 200
  end
end
