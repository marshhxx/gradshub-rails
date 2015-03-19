class AddFieldsToUsers < ActiveRecord::Migration
  def change

    create_table :countries do |t|
      t.string :name, null: false
      t.string :iso_code, null: false
      t.timestamp
    end

    create_table :states do |t|
      t.string :name, null: false
      t.belongs_to :country
      t.string :iso_code
    end

    create_table :users do |t|
      t.string :uid,  null: false

      t.string :name , null: false
      t.string :lastname
      t.string :email, null: false
      t.integer :gender,  default: 2
      t.date :birth
      t.string :image_url
      t.text :tag
      t.string :encrypted_password,     default: "", null: false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.integer :meta_id
      t.string :meta_type

      t.belongs_to :onepgr_account

      t.timestamp
    end
    add_index :users, [:meta_id, :meta_type]

    create_table :candidates do |t|
      t.text :early_life
      t.text :personal_life
      t.string :job_title

      t.belongs_to :country
      t.belongs_to :state

      t.timestamp
    end

    create_table :onepgr_accounts do |t|
      t.string :onepgr_id
      t.string :onepgr_password,        default: "", null: false
      t.string :session_token

      t.timestamp
    end

    create_table :employers do |t|
      t.belongs_to :company_location

      t.timestamp
    end

    create_table :interests do |t|
      t.string :name, null: false
      t.timestamp
    end

    create_table :candidates_interests do |t|
      t.belongs_to :candidate
      t.belongs_to :interest

      t.timestamp
    end
    add_index(:candidates_interests, [:candidate_id, :interest_id], :unique => true)

    create_table :employers_interests do |t|
      t.belongs_to :employer
      t.belongs_to :interest

      t.timestamp
    end
    add_index(:employers_interests, [:employer_id, :interest_id], :unique => true)

    create_table :skills do |t|
      t.string :name, null: false
      t.timestamp
    end
    add_index :skills, :name, :unique => true

    create_table :candidates_skills, id: false do |t|
      t.belongs_to :candidate
      t.belongs_to :skill

      t.timestamp
    end
    add_index(:candidates_skills, [:candidate_id, :skill_id], :unique => true)

    create_table :employers_skills, id: false do |t|
      t.belongs_to :employer
      t.belongs_to :skill

      t.timestamp
    end
    add_index(:employers_skills, [:employer_id, :skill_id], :unique => true)

    create_table :nationalities do |t|
      t.string :name

      t.timestamp
    end

    create_table :candidates_nationalities do |t|
      t.belongs_to :candidate
      t.belongs_to :nationality

      t.timestamp
    end
    add_index(:candidates_nationalities, [:candidate_id, :nationality_id], :unique => true, :name => :candidates_nationalities_index)

    create_table :languages do |t|
      t.string :name

      t.timestamp
    end

    create_table :candidates_languages do |t|
      t.belongs_to :candidate
      t.belongs_to :language
      t.integer :level, default: 0

      t.timestamp
    end
    add_index(:candidates_languages, [:candidate_id, :language_id], :unique => true)

    create_table :experience do |t|
      t.belongs_to :candidate
      t.string :company_name
      t.string :job_title
      t.date :start_date
      t.date :end_date
      t.text :description

      t.timestamp
    end

    create_table :schools do |t|
      t.string :name

      t.timestamp
    end

    create_table :majors do |t|
      t.string :name

      t.timestamp
    end

    create_table :degrees do |t|
      t.string :name

      t.timestamp
    end

    create_table :educations do |t|
      t.belongs_to :candidate
      t.belongs_to :school,     null: false
      t.belongs_to :major,      null: false
      t.belongs_to :degree,     null: false
      t.belongs_to :country
      t.belongs_to :state
      t.text :description
      t.date :start_date,       null: false
      t.date :end_date

      t.timestamp
    end

    create_table :publications do |t|
      t.string :title
      t.string :url
      t.date :date
      t.text :description

      t.timestamp
    end

    create_table :candidates_publications do |t|
      t.belongs_to :candidate
      t.belongs_to :publication

      t.timestamp
    end
    add_index(:candidates_publications, [:candidate_id, :publication_id], :unique => true)

    create_table :companies do |t|
      t.string :name
      t.string :industry
      t.text :description

      t.timestamp
    end

    create_table :company_locations do |t|
      t.belongs_to :company
      t.belongs_to :country
      t.belongs_to :state

      t.timestamp
    end
  end
end
