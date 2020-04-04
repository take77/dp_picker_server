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

ActiveRecord::Schema.define(version: 2020_04_03_103745) do

  create_table "dp_pokemons", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "base_id", default: 0, null: false
    t.boolean "legend", default: false, null: false
    t.integer "weight", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "log_contents", force: :cascade do |t|
    t.integer "log_id"
    t.integer "dp_pokemon_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dp_pokemon_id"], name: "index_log_contents_on_dp_pokemon_id"
    t.index ["log_id", "dp_pokemon_id"], name: "index_log_contents_on_log_id_and_dp_pokemon_id", unique: true
    t.index ["log_id"], name: "index_log_contents_on_log_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.integer "player_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_logs_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "nickname", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "log_contents", "dp_pokemons"
  add_foreign_key "log_contents", "logs"
  add_foreign_key "logs", "players"
end
