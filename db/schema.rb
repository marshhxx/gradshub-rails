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

ActiveRecord::Schema.define(version: 20151120000017) do

  create_table "applications", force: true do |t|
    t.integer  "state",        null: false
    t.integer  "candidate_id"
    t.integer  "job_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidate_interests", force: true do |t|
    t.integer "candidate_id"
    t.integer "interest_id"
  end

  add_index "candidate_interests", ["candidate_id", "interest_id"], name: "index_candidate_interests_on_candidate_id_and_interest_id", unique: true, using: :btree

  create_table "candidate_languages", force: true do |t|
    t.integer "candidate_id",             null: false
    t.integer "language_id",              null: false
    t.integer "level",        default: 0
  end

  add_index "candidate_languages", ["candidate_id", "language_id"], name: "index_candidate_languages_on_candidate_id_and_language_id", unique: true, using: :btree

  create_table "candidate_nationalities", force: true do |t|
    t.integer "candidate_id"
    t.integer "nationality_id"
  end

  add_index "candidate_nationalities", ["candidate_id", "nationality_id"], name: "candidates_nationalities_index", unique: true, using: :btree

  create_table "candidate_publications", force: true do |t|
    t.integer "candidate_id"
    t.integer "publication_id"
  end

  add_index "candidate_publications", ["candidate_id", "publication_id"], name: "index_candidate_publications_on_candidate_id_and_publication_id", unique: true, using: :btree

  create_table "candidate_skills", id: false, force: true do |t|
    t.integer "candidate_id"
    t.integer "skill_id"
  end

  add_index "candidate_skills", ["candidate_id", "skill_id"], name: "index_candidate_skills_on_candidate_id_and_skill_id", unique: true, using: :btree

  create_table "candidates", force: true do |t|
    t.text "summary"
    t.text "early_life"
    t.text "personal_life"
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
    t.string  "other_school"
    t.integer "major_id",     null: false
    t.string  "other_major"
    t.integer "degree_id",    null: false
    t.string  "other_degree"
    t.integer "country_id"
    t.integer "state_id"
    t.text    "description"
    t.date    "start_date"
    t.date    "end_date",     null: false
  end

  create_table "employer_nationalities", force: true do |t|
    t.integer "employer_id"
    t.integer "nationality_id"
  end

  add_index "employer_nationalities", ["employer_id", "nationality_id"], name: "employers_nationalities_index", unique: true, using: :btree

  create_table "employers", force: true do |t|
    t.string "job_title"
    t.string "company_name"
    t.string "company_logo"
    t.string "company_tagline"
    t.string "company_url"
    t.string "company_industry"
    t.string "company_description"
  end

  create_table "experiences", force: true do |t|
    t.integer "candidate_id"
    t.string  "company_name", null: false
    t.string  "job_title",    null: false
    t.date    "start_date",   null: false
    t.date    "end_date"
    t.text    "description"
  end

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "interests", force: true do |t|
    t.string "name", null: false
  end

  create_table "job_post_skills", force: true do |t|
    t.integer  "job_post_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_post_skills", ["job_post_id", "skill_id"], name: "index_job_post_skills_on_job_post_id_and_skill_id", unique: true, using: :btree

  create_table "job_posts", force: true do |t|
    t.string   "title",                        null: false
    t.text     "description"
    t.text     "requirements"
    t.integer  "job_type",     default: 0
    t.integer  "salary_unit",  default: 0
    t.integer  "min_salary"
    t.integer  "max_salary"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "job_state",    default: 0
    t.boolean  "remote",       default: false
    t.integer  "category"
    t.integer  "employer_id"
    t.integer  "country_id"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_posts", ["employer_id"], name: "index_job_posts_on_employer_id", using: :btree

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

  add_index "skills", ["name"], name: "index_skills_on_name", unique: true, using: :btree

  create_table "states", force: true do |t|
    t.string  "name",       null: false
    t.integer "country_id"
    t.string  "iso_code"
  end

  create_table "users", force: true do |t|
    t.boolean  "admin",                  default: false
    t.string   "uid",                                    null: false
    t.string   "name",                                   null: false
    t.string   "lastname"
    t.string   "email",                                  null: false
    t.integer  "gender",                 default: 2
    t.date     "birth"
    t.string   "profile_image"
    t.string   "cover_image"
    t.text     "tag"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "meta_id"
    t.string   "meta_type"
    t.integer  "country_id"
    t.integer  "state_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["meta_id", "meta_type"], name: "index_users_on_meta_id_and_meta_type", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree

end
