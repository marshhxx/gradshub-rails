class User < ActiveRecord::Base
  include ActiveModel::Validations

  devise  :database_authenticatable, :recoverable
  validates :name, :lastname, :email, :presence => true
  validates :email, :presence => true, :email => true
  validates_uniqueness_of :auth_token
  validates_uniqueness_of :email, :case_sensitive => false
  before_create :generate_authentication_token!
  before_create :set_uid

  enum gender: {male: 0, female: 1, other:2}

  belongs_to :meta, polymorphic: true
  has_one :identity, autosave: true

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  # authinticate the user with the given password
  def authenticate_with_password(input_password)
    return false unless self.valid_password?(input_password)
    authenticate
  end

  def authenticate_with_oauth
    return false if self.nil?
    authenticate
  end

  # Finds or creates the user from the auth object.
  #
  # @param auth the oauth integration object.
  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?
      # should we ask if the email is verified? for now, no.
      # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email_is_verified = auth.info.email_address?
      email = auth.info.email_address if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
            name: auth.info.first_name,
            lastname: auth.info.last_name,
            email: email,
            password: Devise.friendly_token[0,20],
            profile_image: auth.info.picture_url,
            tag: auth.info.headline
        )
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
    end
    user
  end

  def self.search(query, limit=50, per_page=0)
    index.query(query_string: {query: query}).limit(limit).load.to_a
  end

  def self.index
    UsersIndex
  end

  protected
  def set_uid
    # This only works before_create obviously, otherwise it would
    # find itself and loop eternally.
    while self.uid.blank? or !User.find_by_uid(self.uid).blank?
      self.uid = '0U' + Digest::SHA1.hexdigest("#{self.name},#{self.lastname},#{self.email}#{Time.current.usec}").slice(0,8)
    end
  end

  def authenticate
    self.generate_authentication_token!
    self.save
  end

end
