class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_with_token!, only: [:update, :destroy]

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