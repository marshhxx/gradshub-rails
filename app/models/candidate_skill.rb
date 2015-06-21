class CandidateSkill < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :skill

  validates_uniqueness_of :skill_id, scope: :candidate_id
end