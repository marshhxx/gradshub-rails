class ModifyCompany < ActiveRecord::Migration
  def change

    change_table :employers do |t|
      t.string :company_name, :company_logo, :company_tagline, :company_url, :company_industry, :company_description
    end

    remove_belongs_to :employers, :employer_company

    drop_table :companies
    drop_table :employer_company

    remove_index :employer_skills, [:employer_id, :skill_id]
    remove_index :employer_interests, [:employer_id, :interest_id]

    drop_table :employer_interests
    drop_table :employer_skills

  end
end
