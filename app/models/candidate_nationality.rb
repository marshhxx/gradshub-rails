class CandidateNationality < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :nationality

  validates_uniqueness_of :nationality_id, scope: :candidate_id
end