class Nationality < ActiveRecord::Base
  # candidate association
  has_many :candidate_nationalities
  has_many :candidates, :through => :candidate_nationalities
  # employer association
  has_many :employer_nationalities
  has_many :employers, :through => :employer_nationalities
end