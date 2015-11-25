class EmployerInterest < ActiveRecord::Base
  belongs_to :employer
  belongs_to :interest

  validates_uniqueness_of :interest_id, scope: :employer_id
end