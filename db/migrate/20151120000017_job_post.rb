class JobPost < ActiveRecord::Migration
  def change

    create_table :job_posts do |t|
      t.string :title, null: false
      t.text :description
      t.text :requirements
      t.integer :type, default: 0
      t.integer :salary_units, default: 0
      t.integer :salary
      t.timestamp :start_date
      t.timestamp :end_date
      t.integer :state, default: 0
      t.belongs_to :employer

      t.timestamp
    end
    add_index :job_posts, :employer_id

    create_table :applications do |t|
      t.integer :state, defualt: 0, null: false
      t.belongs_to :candidate
      t.belongs_to :job_post

      t.timestamp
    end

    create_table :job_post_skills do |t|
      t.belongs_to :job_post
      t.belongs_to :skill

      t.timestamp
    end
    add_index(:job_post_skills, [:job_post_id, :skill_id], :unique => true)

  end
end
