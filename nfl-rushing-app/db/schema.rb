# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_27_215715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "team_id", null: false
    t.bigint "position_id", null: false
    t.index ["position_id"], name: "index_players_on_position_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "rushings", force: :cascade do |t|
    t.float "attempts_per_game"
    t.integer "attempts"
    t.integer "yards"
    t.float "yards_per_attempt"
    t.float "yards_per_game"
    t.integer "tds"
    t.integer "longest"
    t.boolean "is_longest_td"
    t.integer "first_downs"
    t.float "first_down_percentage"
    t.integer "runs_twenty_plus"
    t.integer "runs_forty_plus"
    t.integer "fumbles"
    t.bigint "player_id", null: false
    t.index ["player_id"], name: "index_rushings_on_player_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
  end

  add_foreign_key "players", "positions"
  add_foreign_key "players", "teams"
  add_foreign_key "rushings", "players"
end
