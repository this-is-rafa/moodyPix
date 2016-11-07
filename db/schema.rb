# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161107041615) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pictures", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.json     "vision"
    t.text     "labeldescriptions", default: [],              array: true
    t.float    "labelscores",       default: [],              array: true
    t.text     "colorRGBs",         default: [],              array: true
    t.float    "colorScores",       default: [],              array: true
    t.text     "detectedText"
    t.string   "joy"
    t.string   "sorrow"
    t.string   "anger"
    t.string   "surprise"
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "comment"
    t.integer  "picture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picture_id"], name: "index_reviews_on_picture_id", using: :btree
  end

  add_foreign_key "reviews", "pictures"
end
