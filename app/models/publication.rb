class Publication < ActiveRecord::Base
  # candidate association
  has_many :candidate_publications
  has_many :candidates, through: :candidate_publications
end