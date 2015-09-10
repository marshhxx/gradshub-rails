class CandidateLanguage < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :language
  enum level: [:begginer, :intermediate, :advanced]

  validates_uniqueness_of :language_id, scope: :candidate_id

end
