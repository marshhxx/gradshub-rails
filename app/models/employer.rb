class Employer < ActiveRecord::Base
  has_one :user, as: :meta, dependent: :destroy
  accepts_nested_attributes_for :user
  # nationalities
  has_many :employer_nationalities
  has_many :nationalities, :through => :employer_nationalities

  validates_associated :nationalities
  # elasticsearch index update
  update_index 'users#employer', :self


  def self.find_by_uid(uid)
    check_type User.find_by_uid!(uid)
  end

  def self.find_by_email(email)
    User.find_by(email: email)
  end

  def self.find(id)
    check_type User.find_by_uid!(id)
  end

  # Finds or create the employer for the give auth object. (Auth object
  # saves the information of the oauth integration)
  #
  # @param auth the oauth integration object.
  def self.find_for_oauth(auth, signed_in_resource = nil)
    user = User.find_for_oauth(auth, signed_in_resource)
    if user.new_record?
      employer = Employer.new(user: user)
      employer.save!
    end
    user.meta
  end

  private

  def self.check_type(user)
    if user.meta_type == 'Employer'
      user.meta
    end
  end
end