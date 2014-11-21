class Eduacation < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  belongs_to :major
  belongs_to :degree
end