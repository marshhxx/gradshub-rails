class Employer < ActiveRecord::Base
  has_one :user, as: :meta, dependent: :destroy
  accepts_nested_attributes_for :user
  belongs_to :employer_company
  # nationalities
  has_many :employer_nationalities
  has_many :nationalities, :through => :employer_nationalities
  # interests
  has_many :employer_interests
  has_many :interests, :through => :employer_interests
  # skills
  has_many :employer_skills
  has_many :skills, :through => :employer_skills

  validates_associated :nationalities, :interests, :skills

  def self.find_by_uid(uid)
    check_type User.find_by_uid!(uid)
  end

  def self.find_by_email(email)
    User.find_by(email: email)
  end

  def self.find(id)
    check_type User.find_by_uid!(id)
  end

  private

  def self.check_type(user)
    if user.meta_type == 'Employer'
      user.meta
    end
  end
end