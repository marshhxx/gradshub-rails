class Language < ActiveRecord::Base
  has_many :candidates, :through => :users_languages
end