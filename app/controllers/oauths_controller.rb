# Controller that handles all the oauth integrations.
# For now, we only have linkedn integration but if in
# the future we need to add more integrations(i.e google+),
# a method will be added here.
class OauthsController < ApplicationController

  # GET /oauths/linkedin
  #
  # With the temporary oauth2 token, get the oauth1 token using
  # linkedin gem and get the profile information.
  #
  # returns the session created with linkedin.
  def linkedin
    set_user user_class.find_for_oauth(oauth, current_user)

    if get_user.valid? and get_user.user.authenticate_with_oauth
      @user = get_user.user
      render 'api/v1/sessions/create.json', status: :accepted and return
      # render :template => "api/v1/#{user_type.pluralize}/show", status: :accepted and return
    else
      @error = {:reasons => get_user.user.errors.full_messages, :code => INVALID_PARAMS_ERROR}
      render_api_error and return
    end
  end

  private

  # Creates the Auth object from the params.
  def oauth
    Auth.new(params[:uid], params[:oauth_token], action_name)
  end

  # returns the user instance variable.
  def get_user
    instance_variable_get("@#{user_type}")
  end

  # sets the user instance variable.
  def set_user(resource = nil)
    resource ||= resource_class.find_by!(id: params[:id])
    instance_variable_set("@#{user_type}", resource)
  end

  # return the user class depending on the user type. (Candidate or Employer)
  def user_class
    "#{params[:user_type]}".classify.constantize
  end

  # returns the user type.
  def user_type
    params[:user_type].downcase
  end
end