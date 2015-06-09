class Interest < ActiveRecord::Base
  # candidate association
  has_many :candidate_skills
  has_many :candidates, :through => :candidate_skills
  # employer association
  has_many :employer_skills
  has_many :employers, :through => :employer_skills

  validates_uniqueness_of :name
  before_create :to_lower_case
  after_find :capitalize_name

  private

  def to_lower_case
    self.name = self.name.downcase
  end

  def capitalize_name
    self.name = self.name.capitalize!
  end
end