class Candidate < ActiveRecord::Base
  has_one :user, as: :meta, dependent: :destroy
  accepts_nested_attributes_for :user

  belongs_to :country
  belongs_to :state

  has_many :candidate_languages, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  # interests
  has_many :candidate_interests
  has_many :interests, :through => :candidate_interests
  # skills
  has_many :candidate_skills
  has_many :skills, :through => :candidate_skills
  # publications
  has_many :candidate_publications
  has_many :publications, :through => :candidate_publications
  # nationalities
  has_many :candidate_nationalities
  has_many :nationalities, :through => :candidate_nationalities

  validates_associated :educations, :experiences, :candidate_languages,
                       :interests, :skills, :publications, :nationalities

  def self.find_by_uid(uid)
    check_type User.find_by_uid!(uid)
  end

  def self.find_by_email(email)
    User.find_by(email: email)
  end

  def self.find(id)
    check_type User.find_by_uid!(id)
  end

  def self.check_type(user)
    if user.meta_type == 'Candidate'
      user.meta
    end
  end

end