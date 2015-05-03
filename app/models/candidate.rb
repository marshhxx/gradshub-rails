class Candidate < ActiveRecord::Base
  # include Userable
  has_one :user, as: :meta, dependent: :destroy
  accepts_nested_attributes_for :user

  has_and_belongs_to_many :skills, join_table: 'candidates_skills'
  belongs_to :country
  belongs_to :state
  has_and_belongs_to_many :nationalities
  has_many :candidate_languages, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :publications

  def self.find_by_uid(uid)
    User.find_by_uid!(uid).meta
  end

  def self.find_by_email(email)
    User.find_by(email: email)
  end

  def self.find(id)
    User.find_by_uid!(id).meta
  end

end