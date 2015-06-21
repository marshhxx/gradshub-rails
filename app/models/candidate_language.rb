class CandidateLanguage < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :language
  enum level: {begginer: 0, intermediate: 1, advanced:2}

  validates_uniqueness_of :language_id, scope: :candidate_id

end
