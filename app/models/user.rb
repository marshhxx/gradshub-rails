class User < ActiveRecord::Base
  devise  :database_authenticatable, :recoverable
  validates :name, :lastname, :email, :presence => true
  validates_uniqueness_of :auth_token
  validates_uniqueness_of :email, :case_sensitive => false
  before_create :generate_authentication_token!
  before_create :set_uid
  before_save

  enum gender: {male: 0, female: 1, not_known:2}

  belongs_to :onepgr_account
  belongs_to :meta, polymorphic: true

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  def register_onepgr
    acc = OnepgrAccount.new
    if acc.register(self.email)
      self.onepgr_account = acc
      return true
    end
    self.errors.add(:onepgr_account, acc.onepgr_errors)
    false
  end

  def login_to_onepgr(password)
    acc = OnepgrAccount.new(onepgr_password: password)
    self.onepgr_account = acc
    logged = acc.login
    self.errors.add(:onepgr_account, acc.onepgr_errors) unless logged
    logged
  end

  def has_onepgr
    OnepgrAccount.new.is_user(self.email)
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
