class Company < ActiveRecord::Base
  has_many :employer_companies
  belongs_to :headquarters_state, :class_name => 'State'
  belongs_to :headquarters_country, :class_name => 'Country'
end