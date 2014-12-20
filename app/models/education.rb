class Education < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  belongs_to :major
  belongs_to :degree
  belongs_to :state
end