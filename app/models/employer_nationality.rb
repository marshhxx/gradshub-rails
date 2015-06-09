class EmployerNationality < ActiveRecord::Base
  belongs_to :employer
  belongs_to :nationality

  validates_uniqueness_of :nationality_id, scope: :employer_id
end