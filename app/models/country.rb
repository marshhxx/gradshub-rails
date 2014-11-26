class Country < ActiveRecord::Base
  has_many :states, inverse_of: :country
end