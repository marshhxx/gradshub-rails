class EmployerSkill < ActiveRecord::Base
  belongs_to :employer
  belongs_to :skill

  validates_uniqueness_of :skill_id, scope: :employer_id
end