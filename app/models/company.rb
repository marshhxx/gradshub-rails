class Company < ActiveRecord::Base
  has_many :company_locations, inverse_of: :company
end