class Interest < ActiveRecord::Base
  validates_uniqueness_of :name
  before_create :to_lower_case
  has_and_belongs_to_many :users
  after_find :capitalize_name

  private

  def to_lower_case
    self.name = self.name.downcase
  end

  def capitalize_name
    self.name = self.name.capitalize!
  end
end