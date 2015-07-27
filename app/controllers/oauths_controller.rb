class OauthsController < ApplicationController

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

  def oauth
    Auth.new(params[:uid], params[:oauth_token], action_name)
  end

  def get_user
    instance_variable_get("@#{user_type}")
  end

  def set_user(resource = nil)
    resource ||= resource_class.find_by!(id: params[:id])
    instance_variable_set("@#{user_type}", resource)
  end

  def user_class
    "#{params[:user_type]}".classify.constantize
  end

  def user_type
    params[:user_type].downcase
  end
end