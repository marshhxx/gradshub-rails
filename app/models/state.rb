class State < ActiveRecord::Base
  belongs_to :country, inverse_of: :states
end