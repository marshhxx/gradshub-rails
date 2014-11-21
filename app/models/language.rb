class Country < ActiveRecord::Base
  has_many :users, :through => :users_languages
end