class Candidate < ActiveRecord::Base
  # include Userable
  has_one :user, as: :meta, dependent: :destroy
  accepts_nested_attributes_for :user

  has_and_belongs_to_many :skills
  belongs_to :country
  belongs_to :state
  has_and_belongs_to_many :nationalities
  has_many :languages, :through => :users_languages
  has_many :careers
  has_many :educations
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :publications

  def self.find_by_uid(uid)
    User.find_by_uid!(uid).meta
  end

  def self.find_by_email(email)
    User.find_by(email: email)
  end

end