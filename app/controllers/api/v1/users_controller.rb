class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_with_token!, only: [:update]

  # DELETE /api/users/1
  def destroy
    head :not_implemented
  end

  def create
    set_resource(User.create(user_params))
    @user.password = params[:password]
    @user.save

    unless get_resource.valid?
      @reasons = get_resource.errors
      render 'api/v1/common/error', status: :unprocessable_entity
    end
    if get_resource.save
      render :show, status: :created
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :lastname, :email, :password) if params[:user]
  end

  def query_params
    # this assumes that an album belongs to an artist and has an :artist_id
    # allowing us to filter by this
    params.permit(:name, :email)
  end
end