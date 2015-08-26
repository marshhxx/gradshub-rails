require 'active_support'

class Api::V1::UsersController < Api::BaseController
  wrap_parameters include: [:name, :lastname, :email, :password, :onepgr_password, :gender,
                            :birth, :image_url, :tag, :profile_image, :cover_image]
  before_action :authenticate_with_token!, only: [:update]
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
    if get_resource.user.update(resource_params[:user_attributes]) and get_resource.update(resource_params.slice!(:user_attributes))
      logger.info 'User updated!'
      render :show, status: :accepted and return
    end
    @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
    render_error :unprocessable_entity
  end

  private

  def create_resource
    resource_class.new(resource_params)
  end


  def nest_user_attributes(parameters)
    user_attr = parameters.slice(:name, :lastname, :email, :password, :gender, :birth, :profile_image, :cover_image, :tag)
    parameters.slice!(:name, :lastname, :email, :password, :gender, :birth, :profile_image, :cover_image, :tag, :onepgr_password)
              .merge({:user_attributes => user_attr})
  end

  def user_params
    resource_params[:user_attributes]
  end

  def onepgr_password
    params[resource_name][:onepgr_password]
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:name, :email)
  end

end