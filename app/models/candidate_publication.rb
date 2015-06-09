class CandidatePublication < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :publication

  validates_uniqueness_of :publication_id, scope: :candidate_id
end