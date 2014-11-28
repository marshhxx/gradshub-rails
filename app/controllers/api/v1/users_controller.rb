class Api::V1::UsersController < Api::BaseController
  #before_action :authenticate_with_token!, only: [:update]

  # DELETE /api/users/1
  def destroy
    head :not_implemented
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
    user_params[:birth] = user_params[:birth].to_date
    @user = User.find_by(uid: params[:id])
    if @user.nil?
      @reasons = ["User with uid: #{params[:id]} does not exist."]
      render 'api/v1/common/error', status: :unprocessable_entity
    elsif @user.update(user_params)
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
                                 :job_title, :country_id, :state_id, :skills, :nationalities ) if params[:user]
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:name, :email)
  end
end