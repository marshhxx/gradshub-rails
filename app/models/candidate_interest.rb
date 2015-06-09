class CandidateInterest < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :interest

  validates_uniqueness_of :interest_id, scope: :candidate_id
end