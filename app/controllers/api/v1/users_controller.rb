require 'active_support'

class Api::V1::UsersController < Api::BaseController
  wrap_parameters include: [:name, :lastname, :email, :password, :onepgr_password, :gender,
                            :birth, :image_url, :tag, :profile_image, :cover_image]
  before_action :authenticate_with_token!, only: [:update, :password]
  before_action :set_resource, only: []

  # DELETE /api/users/1
  def destroy
    head :not_implemented
  end

  def show
    set_resource(resource_class.find_by_uid(params[:id]))
    logger.info 'User rendered!'
    respond_with get_resource
  end

  def create
    if resource_class.find_by_email(user_params[:email]).nil?
      set_resource(create_resource)
      unless get_resource.user.valid?
        @error = {:reasons => get_resource.user.errors.full_messages, :code => INVALID_PARAMS_ERROR}
        render_api_error and return
      end
      get_resource.save
      logger.info 'User created!'
      render :nothing => true, :status => :created and return
    end
    @error = {:reasons => ['Email has already been taken.'], :code => INVALID_PARAMS_ERROR}
    render_api_error
  end

  def update
    if get_resource.user.update(update_params[:user_attributes]) and get_resource.update(update_params.slice!(:user_attributes))
      logger.info 'User updated!'
      render :show, status: :accepted and return
    end
    @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
    render_error :unprocessable_entity
  end

  # PATCH /api/{resource_class}/:id/password
  def password
    set_resource(resource_class.find_by_uid(params[:id]))
    if get_resource.user.valid_password? password_params[:old_password] and get_resource.user.update_attribute(:password, password_params[:new_password])
      render :nothing => true, status: :accepted and return
    end
    @error = {:reasons => ['Error while changing the password. Please make sure you passed the correct password.'],
              :code => INVALID_PARAMS_ERROR}
    render_api_error
  end

  private

  def create_resource
    resource_class.new(resource_params)
  end


  def nest_user_attributes(parameters)
    user_attr = parameters.slice(:name, :lastname, :email, :password, :gender, :birth, :profile_image, :cover_image, :tag, :country_id, :state_id)
    parameters.slice!(:name, :lastname, :email, :password, :gender, :birth, :profile_image, :cover_image, :tag, :country_id, :state_id)
              .merge({:user_attributes => user_attr})
  end

  def user_params
    resource_params[:user_attributes]
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:name, :email)
  end

  def password_params
    params.require("#{resource_name}").permit(:old_password, :new_password)
  end

end