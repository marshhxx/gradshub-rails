class Skill < ActiveRecord::Base
  # candidate association
  has_many :candidate_skills
  has_many :candidates, :through => :candidate_skills
  # job post association
  has_many :job_post_skills
  has_many :job_posts, :through => :job_post_skills


  before_create :to_lower_case
  validates_uniqueness_of :name
  after_find :capitalize_name

  private

  def to_lower_case
    self.name = self.name.downcase
  end

  def capitalize_name
    self.name = self.name.capitalize!
  end
end