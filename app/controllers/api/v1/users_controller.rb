class Api::V1::UsersController < Api::BaseController
  #before_action :authenticate_with_token!, only: [:update]

  # DELETE /api/users/1
  def destroy
    head :not_implemented
  end

  def show
    @user = User.find_by_uid(params[:id])
    respond_with get_resource
  end

  def create
    set_resource(User.create(user_params))
    @user.password = params[:password]
    @user.save

    unless get_resource.valid?
      @reasons = get_resource.errors.full_messages
      render 'api/v1/common/error', status: :unprocessable_entity
    end
    if get_resource.save
      render :show, status: :created
    end
  end

  def update
    user_params[:birth] = user_params[:birth].to_date if user_params[:birth]
    @user = User.find_by(uid: params[:id])
    if @user.nil?
      @reasons = ["User with uid: #{params[:id]} does not exist."]
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
      Education.find_or_create_by(user: @user,
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
    }
    if @user.update(user_params)
      render :show, status: :accepted
    else
      @reasons = @user.errors.full_messages
      render 'api/v1/common/error', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :lastname, :email, :password, :gender,
                                 :birth, :image_url, :early_life, :personal_life,
                                 :job_title, :country_id, :state_id, :bio) if params[:user]
  end

  def nationalities_params
    params.require(:user).permit(:nationalities_ids => [])
  end

  def educations_params
    params.require(:user).permit(:educations => [:state_id, :school_id, :major_id, :degree_id])
  end

  def skills_params
    params.require(:user).permit(:skills => [])
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:name, :email)
  end
end