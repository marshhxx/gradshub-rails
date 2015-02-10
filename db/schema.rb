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

ActiveRecord::Schema.define(version: 20141030020738) do

  create_table "careers", force: true do |t|
    t.integer "user_id"
    t.string  "company"
    t.string  "title"
    t.date    "start_date"
    t.text    "description"
  end

  create_table "countries", force: true do |t|
    t.string "name",     null: false
    t.string "iso_code", null: false
  end

  create_table "degrees", force: true do |t|
    t.string "name"
  end

  create_table "educations", force: true do |t|
    t.integer "user_id"
    t.integer "school_id"
    t.integer "major_id"
    t.integer "degree_id"
    t.integer "country_id"
    t.integer "state_id"
  end

  create_table "interests", force: true do |t|
    t.string "name", null: false
  end

  create_table "interests_users", force: true do |t|
    t.integer "user_id"
    t.integer "interest_id"
  end

  add_index "interests_users", ["user_id", "interest_id"], name: "index_interests_users_on_user_id_and_interest_id", unique: true, using: :btree

  create_table "languages", force: true do |t|
    t.string "name"
  end

  create_table "languages_users", force: true do |t|
    t.integer "user_id"
    t.integer "language_id"
    t.integer "level",       default: 0
  end

  add_index "languages_users", ["user_id", "language_id"], name: "index_languages_users_on_user_id_and_language_id", unique: true, using: :btree

  create_table "majors", force: true do |t|
    t.string "name"
  end

  create_table "nationalities", force: true do |t|
    t.string "name"
  end

  create_table "nationalities_users", force: true do |t|
    t.integer "user_id"
    t.integer "nationality_id"
  end

  add_index "nationalities_users", ["user_id", "nationality_id"], name: "index_nationalities_users_on_user_id_and_nationality_id", unique: true, using: :btree

  create_table "publications", force: true do |t|
    t.string "title"
    t.string "url"
    t.date   "date"
    t.text   "description"
  end

  create_table "publications_users", force: true do |t|
    t.integer "user_id"
    t.integer "publication_id"
  end

  add_index "publications_users", ["user_id", "publication_id"], name: "index_publications_users_on_user_id_and_publication_id", unique: true, using: :btree

  create_table "schools", force: true do |t|
    t.string "name"
  end

  create_table "skills", force: true do |t|
    t.string "name", null: false
  end

  create_table "skills_users", force: true do |t|
    t.integer "user_id"
    t.integer "skill_id"
  end

  add_index "skills_users", ["user_id", "skill_id"], name: "index_skills_users_on_user_id_and_skill_id", unique: true, using: :btree

  create_table "states", force: true do |t|
    t.string  "name",       null: false
    t.integer "country_id"
    t.string  "iso_code"
  end

  create_table "users", force: true do |t|
    t.string   "uid",                                 null: false
    t.string   "name",                                null: false
    t.string   "lastname"
    t.string   "email",                               null: false
    t.integer  "gender",                 default: 2
    t.date     "birth"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "onepgr_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "image_url"
    t.text     "early_life"
    t.text     "personal_life"
    t.text     "bio"
    t.string   "job_title"
    t.integer  "country_id"
    t.integer  "state_id"
    t.string   "auth_token",             default: ""
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree

end
