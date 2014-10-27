class User < ActiveRecord::Base
  validates :name, :lastname, :email, :password, :presence => true
end