class User < ActiveRecord::Base
  devise  :database_authenticatable
  validates :name, :lastname, :email, :presence => true
  validates_uniqueness_of :auth_token
  validates_uniqueness_of :email, :case_sensitive => false

  before_create :generate_authentication_token!
  before_create :set_uid

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
      self.uid = Digest::SHA1.hexdigest("#{self.name},#{self.lastname},#{self.email}#{Time.current.usec}")
    end
  end
end
