class UserLanguage < ActiveRecord::Base
  belongs_to :user
  belongs_to :language
  enum level: {begginer: 0, intermidiate: 1, advanced:2}
end