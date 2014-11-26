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

      t.string :image_url
      t.text :early_life
      t.text :personal_life
      t.string :job_title

      t.belongs_to :country
      t.belongs_to :state

      t.timestamp
    end

    create_table :skills do |t|
      t.string :name, null: false
      t.timestamp
    end

    create_table :users_skills do |t|
      t.belongs_to :users
      t.belongs_to :skills
    end

    create_table :nationalities do |t|
      t.string :name
      t.timestamp
    end

    create_table :users_nationality do |t|
      t.belongs_to :user
      t.belongs_to :nationality
      t.timestamp
    end

    create_table :languages do |t|
      t.string :name
      t.timestamp
    end

    create_table :users_languages do |t|
      t.belongs_to :user
      t.belongs_to :language
      t.integer :level, default: 0
      t.timestamp
    end

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
      t.timestamp
    end

    create_table :publications do |t|
      t.string :title
      t.string :url
      t.date :date
      t.text :description
      t.timestamp
    end

    create_table :users_publications do |t|
      t.belongs_to :user
      t.belongs_to :publication
    end
  end
end
