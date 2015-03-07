class OnepgrAccount < ActiveRecord::Base
  has_one :user
  attr_accessor :onepgr_errors, :session_cookies, :headers

  def login
    if Rails.env.development?
      return true
    end
    begin
      client = get_client('/sessions/create3')
      raw_resp = client.post(parse_login_params)
      response = parse_response(raw_resp, 'reason')
      self.onepgr_id = response['user_id']
      self.session_token = raw_resp.cookies['api_sessionid']
      self.session_cookies = raw_resp.cookies
      return self.save
    rescue StandardError => error
      logger.error error
      false
    end
  end

  def register(email)
    if Rails.env.development?
      return true
    end
    begin
      client = get_client('/users/create_api')
      response = parse_response(client.post(parse_register_params(email)), 'message')
      self.onepgr_id = response['user_id']
      self.onepgr_password = response['user_password']
      return self.save
    rescue StandardError => error
      logger.error error
      false
    end
  end

  def create_page
    unless login
      return false
    end
    begin
      client = get_client('/pages/create3_api')
      response = parse_response(client.post(parse_create_page_params,
                                            :cookies => self.session_cookies),
                                'reason')
      return {page_id: response['page_id'], page_passcode: response['page_passcode']}
    rescue StandardError => error
      logger.error error
    end
  end

  def invite_user_to_page(user, page_params)
    if Rails.env.development?
      return true
    end
    begin
      client = get_client('/onepgrapi/invite_user_api')
      response = parse_response(client.post(parse_invite_user_to_page_params(user, page_params),
                                            :cookies => self.session_cookies),
                                'reason')
      return true
    rescue StandardError => error
      logger.error error
      false
    end
  end

  private

  ONEPGR_URL = 'http://onepgr.com'
  ONEPGR_CLIENT_NAME = 11
  ONEPGR_APP_ID = 22
  ONEPGR_APP_KEY = 33


  def parse_response(response, attr_name)
    response_args = JSON.parse(JSON.parse(response.body)['response'])
    success_code = Integer(response_args['success'])
    if success_code >= 0
      return response_args
    end
    self.onepgr_errors = (response_args[attr_name])
    raise StandardError
  end


  def parse_login_params
    URI::encode_www_form({
      :login => self.user.email,
      :password => self.onepgr_password,
      :clientname => ONEPGR_CLIENT_NAME,
      :clientappid => ONEPGR_APP_ID,
      :clientappkey => ONEPGR_APP_KEY
    })
  end

  def parse_register_params(email)
    URI::encode_www_form({
      :email => email,
      :onepgr_apicall => 1,
      :clientname => ONEPGR_CLIENT_NAME,
      :clientappid => ONEPGR_APP_ID,
      :clientappkey => ONEPGR_APP_KEY
    })
  end

  def parse_create_page_params
    URI::encode_www_form({
      :onepgr_apicall => 1,
      :user_id => self.onepgr_id,
      :session_token => self.session_token,
      :name => "Call from #{[self.user.name, self.user.lastname].join(' ')}"
    })
  end

  def parse_invite_user_to_page_params(user, page_params)
    URI::encode_www_form({
        :clientname => ONEPGR_CLIENT_NAME,
        :clientappid => ONEPGR_APP_ID,
        :clientappkey => ONEPGR_APP_KEY,
        :onepgr_apicall => 1,
        :id => page_params[:page_id],
        :passcode => page_params[:page_passcode],
        :user_orgid => 101,
        :requestor_name => "#{[self.user.name, self.user.lastname].join(' ')}",
        :requestor_email => self.user.email,
        :account_email => user.email,
        :msg => "Please follow this link: #{ONEPGR_URL}/pages/#{page_params[:page_id]}"
    })
  end

  def get_client(url)
    RestClient::Resource.new ONEPGR_URL + url, :content_type => 'application/x-www-form-urlencoded'
  end
end