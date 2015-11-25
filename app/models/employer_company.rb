class EmployerCompany < ActiveRecord::Base
  self.table_name  = 'employer_company'
  belongs_to :company
  belongs_to :country
  belongs_to :state
end