require 'active_support'

class Api::V1::UsersController < Api::BaseController
  wrap_parameters include: [:name, :lastname, :email, :password, :onepgr_password, :gender,
                            :birth, :image_url, :tag]
  before_action :authenticate_with_token!, only: [:update]

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
      if get_resource.user.has_onepgr
        if onepgr_password.nil?
          @error = {
              :reasons => ['The user already has a onepgr account, the password needs to be provided'],
              :code => ONEPGR_REGISTER_ERROR
          }
          render_api_error and return
        end
        unless get_resource.user.login_to_onepgr(onepgr_password)
          @error = {:reasons => get_resource.user.errors.full_messages, :code => ONEPGR_AUTH_ERROR}
          render_api_error and return
        end
      else
        unless get_resource.user.register_onepgr
          @error = {:reasons => get_resource.user.errors.full_messages, :code => ONEPGR_REGISTER_ERROR}
        end
      end
      unless get_resource.user.valid?
        @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
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
    resource_params[:birth] = resource_params[:birth].to_date if resource_params[:birth]
    set_resource(resource_class.find_by_uid(params[:id]))
    if get_resource.update(resource_params)
      logger.info 'User updated!'
      render :show, status: :accepted and return
    end
    @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
    render_error :unprocessable_entity
  end

  def update_old
    user_params[:birth] = user_params[:birth].to_date if user_params[:birth]
    @user = User.find_by(uid: params[:id])
    if @user.nil?
      @error = {:reasons => ["User with uid: #{params[:id]} does not exist."],
                :code => INVALID_PARAMS_ERROR}
      render 'api/v1/common/error', status: :unprocessable_entity
      return
    end
    nationalities_params[:nationalities_ids].map {|id|
      nationality = Nationality.find(id)
      unless @user.nationalities.include?(nationality)
        @user.nationalities << nationality
      end
    } if nationalities_params[:nationalities_ids]

    educations_params[:educations].map { |raw_edu|
      Education.find_or_create_by(
          user: @user,
          country: Country.find(raw_edu[:country_id]),
          state: State.find(raw_edu[:state_id]),
          school: School.find(raw_edu[:school_id]),
          major: Major.find(raw_edu[:major_id]),
          degree: Degree.find(raw_edu[:degree_id]) )
    } if educations_params[:educations]

    skills_params[:skills].map {|skill_name|
      skill = Skill.find_or_create_by(name: skill_name)
      unless @user.skills.include?(skill)
        @user.skills << skill
      end
    } if skills_params[:skills]

    interests_params[:interests].map { |interest_name|
      interest = Interest.find_or_create_by(name: interest_name)
      unless @user.skills.include?(interest)
        @user.interests << interest
      end
    } if interests_params[:interests]
    if @user.update(user_params)
      logger.info 'User updated!'
      render :show, status: :accepted
    else
      @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
      render 'api/v1/common/error', status: :unprocessable_entity
    end
  end

  private

  def create_resource
    resource_class.new(resource_params)
  end


  def nest_user_attributes(parameters)
    user_attr = parameters.slice(:name, :lastname, :email, :password, :gender, :birth, :image_url, :tag)
    parameters.slice!(:name, :lastname, :email, :password, :gender, :birth, :image_url, :tag, :onepgr_password)
              .merge({:user_attributes => user_attr})
  end

  def user_params
    resource_params[:user_attributes]
  end

  def onepgr_password
    params[resource_name][:onepgr_password]
  end

  def nationalities_params
    params.require(:user).permit(:nationalities_ids => [])
  end

  def educations_params
    params.require(:user).permit(:educations => [:country_id, :state_id, :school_id, :major_id, :degree_id])
  end

  def skills_params
    params.require(:user).permit(:skills => [])
  end

  def interests_params
    params.require(:user).permit(:interests => [])
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:name, :email)
  end
end