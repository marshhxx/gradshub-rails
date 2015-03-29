class Company < ActiveRecord::Base
  has_many :employer_companies
end