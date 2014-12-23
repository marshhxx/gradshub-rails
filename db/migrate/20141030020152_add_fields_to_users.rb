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
      t.string :encrypted_password,     default: "", null: false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.string :image_url
      t.text :early_life
      t.text :personal_life
      t.text :bio
      t.string :job_title

      t.belongs_to :country
      t.belongs_to :state

      t.timestamp
    end

    create_table :interests do |t|
      t.string :name, null: false
      t.timestamp
    end

    create_table :interests_users do |t|
      t.belongs_to :user
      t.belongs_to :interest
    end
    add_index(:interests_users, [:user_id, :interest_id], :unique => true)

    create_table :skills do |t|
      t.string :name, null: false
      t.timestamp
    end

    create_table :skills_users do |t|
      t.belongs_to :user
      t.belongs_to :skill
    end
    add_index(:skills_users, [:user_id, :skill_id], :unique => true)

    create_table :nationalities do |t|
      t.string :name
      t.timestamp
    end

    create_table :nationalities_users do |t|
      t.belongs_to :user
      t.belongs_to :nationality
      t.timestamp
    end
    add_index(:nationalities_users, [:user_id, :nationality_id], :unique => true)

    create_table :languages do |t|
      t.string :name
      t.timestamp
    end

    create_table :languages_users do |t|
      t.belongs_to :user
      t.belongs_to :language
      t.integer :level, default: 0
      t.timestamp
    end
    add_index(:languages_users, [:user_id, :language_id], :unique => true)

    create_table :careers do |t|
      t.belongs_to :user
      t.string :company
      t.string :title
      t.date :start_date
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
      t.belongs_to :user
      t.belongs_to :school
      t.belongs_to :major
      t.belongs_to :degree
      t.belongs_to :country
      t.belongs_to :state
      t.timestamp
    end

    create_table :publications do |t|
      t.string :title
      t.string :url
      t.date :date
      t.text :description
      t.timestamp
    end

    create_table :publications_users do |t|
      t.belongs_to :user
      t.belongs_to :publication
    end
    add_index(:publications_users, [:user_id, :publication_id], :unique => true)
  end
end
