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

ActiveRecord::Schema.define(version: 20161108202400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "colors", force: :cascade do |t|
    t.string   "rgb1"
    t.string   "rgb2"
    t.string   "rgb3"
    t.string   "rgb4"
    t.string   "rgb5"
    t.string   "rgb6"
    t.string   "rgb7"
    t.string   "rgb8"
    t.string   "rgb9"
    t.string   "rgb10"
    t.float    "score1"
    t.float    "score2"
    t.float    "score3"
    t.float    "score4"
    t.float    "score5"
    t.float    "score6"
    t.float    "score7"
    t.float    "score8"
    t.float    "score9"
    t.float    "score10"
    t.integer  "picture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picture_id"], name: "index_colors_on_picture_id", using: :btree
  end

  create_table "labels", force: :cascade do |t|
    t.string   "label1"
    t.string   "label2"
    t.string   "label3"
    t.string   "label4"
    t.string   "label5"
    t.string   "label6"
    t.string   "label7"
    t.string   "label8"
    t.string   "label9"
    t.string   "label10"
    t.float    "score1"
    t.float    "score2"
    t.float    "score3"
    t.float    "score4"
    t.float    "score5"
    t.float    "score6"
    t.float    "score7"
    t.float    "score8"
    t.float    "score9"
    t.float    "score10"
    t.integer  "picture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picture_id"], name: "index_labels_on_picture_id", using: :btree
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "comment"
    t.integer  "picture_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["picture_id"], name: "index_reviews_on_picture_id", using: :btree
  end

  add_foreign_key "colors", "pictures"
  add_foreign_key "labels", "pictures"
  add_foreign_key "reviews", "pictures"
end
