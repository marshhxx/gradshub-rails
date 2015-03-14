class CompanyLocation < ActiveRecord::Base
  belongs_to :company
  belongs_to :country
  belongs_to :state
end