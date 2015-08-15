class Company < ActiveRecord::Base
  has_many :employer_companies
  belongs_to :headquarters_state, :class_name => 'State'
  belongs_to :headquarters_country, :class_name => 'Country'

  # Creates a company from a linkedin company.
  def self.from_linkedin(company)
    self.new(
        name: company.name,
        industry: company.industry,
        category: company.type,
        size: company.size
    ) if not self.find_by_name(company.name)
  end
end