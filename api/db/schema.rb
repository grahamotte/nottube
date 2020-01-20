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

ActiveRecord::Schema.define(version: 2020_01_20_050648) do

  create_table "subscriptions", force: :cascade do |t|
    t.string "channel_id"
    t.string "url", null: false
    t.string "title"
    t.string "thumbnail_url"
    t.text "description"
    t.integer "video_count"
    t.integer "subscriber_count"
    t.integer "keep"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "keep_count", default: 8, null: false
    t.integer "look_back_count", default: 32, null: false
  end

  create_table "videos", force: :cascade do |t|
    t.integer "subscription_id"
    t.string "video_id"
    t.datetime "published_at"
    t.string "title"
    t.string "thumbnail_url"
    t.string "file_name"
    t.text "description"
    t.integer "duration"
    t.boolean "to_download", default: false, null: false
    t.boolean "downloaded", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
