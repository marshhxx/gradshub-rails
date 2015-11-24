class JobPost < ActiveRecord::Migration
  def change
    create_table :job_posts do |t|
      t.string :title, null: false
      t.string :description
      t.string :requirements
      t.string :type
      t.string :salary
      t.timestamps :start_date
      t.timestamps :end_date
      t.string :state

      t.belongs_to :employer
    end

    create_table :applications do |t|
      t.string :state
      t.timestamps :start_date

      t.belongs_to :candidate
      t.belongs_to :job_post
    end

    add_belongs_to :skills, :job_post
  end
end
