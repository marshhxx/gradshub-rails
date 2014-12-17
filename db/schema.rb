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
  end

  create_table "languages", force: true do |t|
    t.string "name"
  end

  create_table "majors", force: true do |t|
    t.string "name"
  end

  create_table "nationalities", force: true do |t|
    t.string "name"
  end

  create_table "publications", force: true do |t|
    t.string "title"
    t.string "url"
    t.date   "date"
    t.text   "description"
  end

  create_table "schools", force: true do |t|
    t.string "name"
  end

  create_table "skills", force: true do |t|
    t.string "name", null: false
  end

  create_table "states", force: true do |t|
    t.string  "name",       null: false
    t.integer "country_id"
    t.string  "iso_code"
  end

  create_table "users", force: true do |t|
    t.string  "uid",                             null: false
    t.string  "name",                            null: false
    t.string  "lastname"
    t.string  "email",                           null: false
    t.integer "gender",             default: 2
    t.date    "birth"
    t.string  "encrypted_password", default: "", null: false
    t.string  "image_url"
    t.text    "early_life"
    t.text    "personal_life"
    t.string  "job_title"
    t.integer "country_id"
    t.integer "state_id"
    t.string  "auth_token",         default: ""
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree

  create_table "users_languages", force: true do |t|
    t.integer "user_id"
    t.integer "language_id"
    t.integer "level",       default: 0
  end

  create_table "users_nationality", force: true do |t|
    t.integer "user_id"
    t.integer "nationality_id"
  end

  create_table "users_publications", force: true do |t|
    t.integer "user_id"
    t.integer "publication_id"
  end

  create_table "users_skills", force: true do |t|
    t.integer "users_id"
    t.integer "skills_id"
  end

end
