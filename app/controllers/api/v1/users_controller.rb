class Api::V1::UsersController < Api::BaseController
  before_action :authenticate_with_token!, only: [:update]

  # DELETE /api/users/1
  def destroy
    head :not_implemented
  end

  def show
    @user = User.find_by_uid(params[:id])
    if @user.nil?
      @error = {:reasons => ["User with uid #{params[:id]} doesn't exist."],
                :code => INVALID_PARAMS_ERROR}
      render 'api/v1/common/error', status: :unprocessable_entity
    else
      logger.info 'User rendered!'
      respond_with get_resource
    end
  end

  def create
    if User.find_by(email: user_params[:email]).nil?
      set_resource(User.new(user_params))
      if params[:onepgr_password].nil?
        unless @user.register_onepgr(user_params)
          @error = {:reasons => @user.errors.full_messages, :code => ONEPGR_REGISTER_ERROR}
          render 'api/v1/common/error', status: :unprocessable_entity
          return
        end
      else
        unless @user.login_to_onepgr(params[:onepgr_password])
          @error = {:reasons => @user.errors.full_messages, :code => ONEPGR_AUTH_ERROR}
          render 'api/v1/common/error', status: :unprocessable_entity
          return
        end
      end
      @user.password = params[:password]
      @user.save
      unless get_resource.valid?
        @error = {:reasons => get_resource.errors.full_messages, :code => INVALID_PARAMS_ERROR}
        render 'api/v1/common/error', status: :unprocessable_entity
        return
      end
      logger.info 'User created!'
      render :nothing => true, :status => :created
    else
      @error = {:reasons => ['Email has already been taken.'], :code => INVALID_PARAMS_ERROR}
      render 'api/v1/common/error', status: :unprocessable_entity
    end
  end

  def update
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

  def register_user

  end

  def user_params
    params.require(:user).permit(:name, :lastname, :email, :password,
                                 :gender, :birth, :image_url, :early_life, :personal_life,
                                 :job_title, :country_id, :state_id, :bio) if params[:user]
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