# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140202212111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "contacts", force: true do |t|
    t.integer  "user_id"
    t.string   "key"
    t.hstore   "data",       default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.integer  "contact_id"
    t.integer  "user_id"
    t.text     "description"
    t.hstore   "data",          default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "original_data", default: {}
  end

  add_index "events", ["contact_id"], name: "index_events_on_contact_id", using: :btree
  add_index "events", ["description"], name: "index_events_on_description", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contacts_count", default: 0
    t.boolean  "sent",           default: false
  end

  create_table "messageships", force: true do |t|
    t.integer  "message_id"
    t.integer  "segment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messageships", ["message_id"], name: "index_messageships_on_message_id", using: :btree
  add_index "messageships", ["segment_id"], name: "index_messageships_on_segment_id", using: :btree

  create_table "segmentizations", force: true do |t|
    t.integer  "segment_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "segments", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "conditions",            default: "--- []\n"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "segmentizations_count", default: 0
  end

  add_index "segments", ["user_id"], name: "index_segments_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_key"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "events_count",           default: 0
    t.integer  "contacts_count",         default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
