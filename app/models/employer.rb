class Employer < ActiveRecord::Base
  has_one :user, as: :meta, dependent: :destroy
  accepts_nested_attributes_for :user

  has_and_belongs_to_many :interests
  belongs_to :company_location
  has_and_belongs_to_many :skills, join_table: 'employers_skills'


  def self.find_by_uid(uid)
    User.find_by_uid!(uid).meta
  end

  def self.find_by_email(email)
    User.find_by(email: email)
  end
end