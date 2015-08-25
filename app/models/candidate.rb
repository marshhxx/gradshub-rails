class Candidate < ActiveRecord::Base
  has_one :user, as: :meta, dependent: :destroy, autosave: true
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

  #transient attributes
  attr_accessor :current_position

  validates_associated :educations, :experiences, :candidate_languages,
                       :interests, :skills, :publications, :nationalities
  # elasticsearch index update
  update_index 'users#candidate', :self

  def self.find_by_uid(uid)
    check_type User.find_by_uid!(uid)
  end

  def self.find_by_email(email)
    User.find_by(email: email)
  end

  def self.find(id)
    check_type User.find_by_uid!(id)
  end

  # Finds or create the candidate for the give auth object. (Auth object
  # saves the information of the oauth integration)
  #
  # @param auth the oauth integration object.
  def self.find_for_oauth(auth, signed_in_resource = nil)
    user = User.find_for_oauth(auth, signed_in_resource)
    if user.new_record?
      country = Country.find_by_name(auth.info.location.name)
      experiences = auth.info.positions.all.map {
          |position| Experience.from_linkedin(position) if position
      }
      candidate = Candidate.new(
          user: user,
          summary: auth.info.summary,
          country: country,
          state: country ? country.states.sample : nil,
          experiences: experiences
      )
      candidate.save!
    end
    user.meta
  end

  # Transient property for displaying the latest position while searching.
  def current_position
    @current_position ||= calculate_position
  end

  def calculate_position
    ongoing = self.experiences.map { |e| e if !e.end_date }.compact
    positions = ongoing.any? ? ongoing : self.experiences
    sorted = positions.sort {
        |left, right| left.start_date <=> right.start_date
    }
    sorted[0] if sorted.any?
  end

  private

  def self.check_type(user)
    if user.meta_type == 'Candidate'
      user.meta
    end
  end

end