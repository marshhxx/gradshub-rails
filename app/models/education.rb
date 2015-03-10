class Education < ActiveRecord::Base
  belongs_to :candidate
  belongs_to :school
  belongs_to :major
  belongs_to :degree
  belongs_to :country
  belongs_to :state
end