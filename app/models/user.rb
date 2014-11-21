class User < ActiveRecord::Base
  devise  :database_authenticatable
  validates :name, :lastname, :email, :presence => true
  validates_uniqueness_of :auth_token
  validates_uniqueness_of :email, :case_sensitive => false
  before_create :generate_authentication_token!
  before_create :set_uid

  enum gender: {male: 0, female: 1, not_known:2}
  has_and_belongs_to_many :skills
  has_one :country
  has_one :state
  has_and_belongs_to_many :nationality
  has_many :languages, :through => :users_languages
  has_many :careers
  has_many :eduacations
  serialize :interests, Array
  has_and_belongs_to_many :publications

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  protected
  def set_uid
    # This only works before_create obviously, otherwise it would
    # find itself and loop eternally.
    while self.uid.blank? or !User.find_by_uid(self.uid).blank?
      self.uid = '0U' + Digest::SHA1.hexdigest("#{self.name},#{self.lastname},#{self.email}#{Time.current.usec}").slice(0,8)
    end
  end
end
