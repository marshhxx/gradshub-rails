class Skill < ActiveRecord::Base
  before_create :to_lower_case
  validates_uniqueness_of :name
  has_and_belongs_to_many :candidates, join_table: 'candidates_skills'
  has_and_belongs_to_many :employers, join_table: 'employers_skills'
  after_find :capitalize_name

  private

  def to_lower_case
    self.name = self.name.downcase
  end

  def capitalize_name
    self.name = self.name.capitalize!
  end
end