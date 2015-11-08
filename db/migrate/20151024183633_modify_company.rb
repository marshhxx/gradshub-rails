class ModifyCompany < ActiveRecord::Migration
  def change

    change_column_null(:educations, :start_date, true)
    change_column_null(:educations, :end_date, false, DateTime.now)

    change_table :employers do |t|
      t.string :company_name, :company_logo, :company_tagline, :company_url, :company_industry, :company_description
    end

    remove_belongs_to :employers, :employer_company

    drop_table :companies
    drop_table :employer_company

  end
end
