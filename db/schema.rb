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

  create_table "candidates", force: true do |t|
    t.text    "summary"
    t.text    "early_life"
    t.text    "personal_life"
    t.integer "country_id"
    t.integer "state_id"
  end

  create_table "candidates_interests", force: true do |t|
    t.integer "candidate_id"
    t.integer "interest_id"
  end

  add_index "candidates_interests", ["candidate_id", "interest_id"], name: "index_candidates_interests_on_candidate_id_and_interest_id", unique: true, using: :btree

  create_table "candidates_languages", force: true do |t|
    t.integer "candidate_id"
    t.integer "language_id"
    t.integer "level",        default: 0
  end

  add_index "candidates_languages", ["candidate_id", "language_id"], name: "index_candidates_languages_on_candidate_id_and_language_id", unique: true, using: :btree

  create_table "candidates_nationalities", force: true do |t|
    t.integer "candidate_id"
    t.integer "nationality_id"
  end

  add_index "candidates_nationalities", ["candidate_id", "nationality_id"], name: "candidates_nationalities_index", unique: true, using: :btree

  create_table "candidates_publications", force: true do |t|
    t.integer "candidate_id"
    t.integer "publication_id"
  end

  add_index "candidates_publications", ["candidate_id", "publication_id"], name: "index_candidates_publications_on_candidate_id_and_publication_id", unique: true, using: :btree

  create_table "candidates_skills", id: false, force: true do |t|
    t.integer "candidate_id"
    t.integer "skill_id"
  end

  add_index "candidates_skills", ["candidate_id", "skill_id"], name: "index_candidates_skills_on_candidate_id_and_skill_id", unique: true, using: :btree

  create_table "companies", force: true do |t|
    t.string "name"
    t.string "industry"
  end

  create_table "countries", force: true do |t|
    t.string "name",     null: false
    t.string "iso_code", null: false
  end

  create_table "degrees", force: true do |t|
    t.string "name"
  end

  create_table "educations", force: true do |t|
    t.integer "candidate_id"
    t.integer "school_id",    null: false
    t.integer "major_id",     null: false
    t.integer "degree_id",    null: false
    t.integer "country_id"
    t.integer "state_id"
    t.text    "description"
    t.date    "start_date",   null: false
    t.date    "end_date"
  end

  create_table "employer_company", force: true do |t|
    t.integer "company_id"
    t.integer "country_id"
    t.integer "state_id"
    t.text    "description"
  end

  create_table "employers", force: true do |t|
    t.integer "employer_company_id"
  end

  create_table "employers_interests", force: true do |t|
    t.integer "employer_id"
    t.integer "interest_id"
  end

  add_index "employers_interests", ["employer_id", "interest_id"], name: "index_employers_interests_on_employer_id_and_interest_id", unique: true, using: :btree

  create_table "employers_skills", id: false, force: true do |t|
    t.integer "employer_id"
    t.integer "skill_id"
  end

  add_index "employers_skills", ["employer_id", "skill_id"], name: "index_employers_skills_on_employer_id_and_skill_id", unique: true, using: :btree

  create_table "experiences", force: true do |t|
    t.integer "candidate_id"
    t.string  "company_name", null: false
    t.string  "job_title",    null: false
    t.date    "start_date",   null: false
    t.date    "end_date"
    t.text    "description"
  end

  create_table "interests", force: true do |t|
    t.string "name", null: false
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

  create_table "onepgr_accounts", force: true do |t|
    t.string "onepgr_id"
    t.string "onepgr_password", default: "", null: false
    t.string "session_token"
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

  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

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
    t.string   "profile_image"
    t.string   "cover_image"
    t.text     "tag"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "meta_id"
    t.string   "meta_type"
    t.integer  "onepgr_account_id"
    t.string   "auth_token",             default: ""
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["meta_id", "meta_type"], name: "index_users_on_meta_id_and_meta_type", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree

end
